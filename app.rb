require "pry"
require "sinatra"
require "sinatra/reloader"
require './lib/encrypting_and_decrypting'
require "./lib/game"
require "./lib/game_holder"
require 'pusher'
require "json"
require "sinatra/json"
$data_base = {}
class App < Sinatra::Base
  MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key

  get("/") do
    slim(:welcome_join)
  end

  post('/uno') do
    client_num = params["client_number"].to_i
    if $data_base[client_num].game.player.cards_left == 1
      uno = params["uno"]
      if uno == "yes"
        $data_base[client_num].player_said_uno
      end
    else
      $data_base[client_num].game.player.take_cards($data_base[client_num].game.draw_cards(2))
    end
    redirect("/game?client_number=#{encrypt_client_number client_num}")
  end

  post('/join_game') do
    player_name = params["name"].strip
    if player_name == ''
      redirect("/")
    else
      $data_base[$data_base.length] = (GameHolder.new(game: Game.new, player_name: player_name))
      redirect("/game?client_number=#{encrypt_client_number($data_base.length - 1)}")
    end
  end

  get("/game") do
    if $data_base[client_number]
      slim(:game)
    else
      redirect("/")
    end
  end

  post("/game") do
    hash = {status: 200}
    if params == {}
      json_object = JSON.parse(request.body.read)
      client_num = json_object["client_number"].to_i
      if not $data_base[client_num].game.game_over?
        card = json_object["card"].split.map(&:capitalize).join(' ')
      else
        @winner = $data_base[client_num].game.game_over?
        $data_base.delete(client_num)
        redirect("/game")
        return json hash
      end
    else
      if params["color"] != nil
        client_num = client_number
        if not $data_base[client_num].game.game_over?
          card = params["color"]
        else
          @winner = $data_base[client_num].game.game_over?
          $data_base.delete(client_num)
          redirect("/game")
          return json hash
        end
      else
        client_num = params["client_number"].to_i
        if not $data_base[client_num].game.game_over?
          if params["color_request"] != nil
            card = params["color_request"]
          end
        else
          @winner = $data_base[client_num].game.game_over?
          $data_base.delete(client_num)
          redirect("/game")
          return json hash
        end
      end
    end
    if $data_base[client_num].must_say_uno == "yes"
      $data_base[client_num].game.player.take_cards($data_base[client_num].game.draw_cards(2))
      $data_base[client_num].change_message("You forgot to say uno")
      $data_base[client_num].player_said_uno
      redirect("/game?client_number=#{encrypt_client_number client_num}")
    end
    if card.split(" ").length == 1 && $data_base[client_num].wild_card_holder != nil
      card_to_play = $data_base[client_num].wild_card_holder
      $data_base[client_num].reset_wild_card_holder
      color = card
      result = $data_base[client_num].game.play_a_round(card_to_play, color)
      $data_base[client_num].reset_message
    else
      if card == "Color Wild"
        $data_base[client_num].set_wild_card_holder("Color Wild")
        $data_base[client_num].change_message("What Color do You want to change it to?")
        redirect("/game?client_number=#{encrypt_client_number client_num}")
        return json hash
      elsif card == "Color Wild Draw Four"
        $data_base[client_num].set_wild_card_holder("Color Wild Draw Four")
        $data_base[client_num].change_message("What Color do You want to change it to?")
        redirect("/game?client_number=#{encrypt_client_number client_num}")
        return json hash
      else
        card_to_play = card
      end
      result = $data_base[client_num].game.play_a_round(card_to_play)
    end
    $data_base[client_num].change_message(result)
    if result == "You can't play that" || result == "You can't play that because you don't have it"

      redirect("/game?client_number=#{encrypt_client_number client_num}")
      return json hash
    else
      $data_base[client_num].add_what_happened($data_base[client_num].game.bots_turn)
      $data_base[client_num].add_what_happened([["Round", $data_base[client_num].round.to_s]])
      $data_base[client_num].increase_round
      if $data_base[client_num].game.player.cards_left == 1
        $data_base[client_num].player_needs_to_say_uno
      end
      if $data_base[client_num].game.player.cards_left == 2
        $data_base[client_num].player_said_uno
      end
      redirect("/game?client_number=#{encrypt_client_number client_num}")
      return json hash
    end
  end

  private

  def client_number
    decrypt_client_number(params['client_number'])
  end

  def encrypt_client_number(number)
    "hello-#{number.to_s}-dolly".encrypt(MESSAGE_KEY)
  end

  def decrypt_client_number(text)
    text.decrypt(MESSAGE_KEY).split('-')[1].to_i
  end
end
