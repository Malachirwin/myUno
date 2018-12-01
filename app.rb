require "pry"
require "sinatra"
require "sinatra/reloader"
#require './lib/encrypting_and_decrypting'
require "./lib/game"
require 'pusher'
require "json"
require "sinatra/json"
$player = nil
$result = nil
$game = nil
$what_happened = []
$must_say_uno = "no"
class App < Sinatra::Base
  # MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key
  # NUMBER_OF_PLAYERS = 4
  def pusher_client
    @pusher_client ||= Pusher::Client.new(
      app_id: "547002",
      key: "e09b3296658d893c5367",
      secret: "1b2821037b4218f1ee2c",
      cluster: "us2"
    )
  end

  get("/") do
    slim(:welcome_join)
  end

  get("/hello") do
    slim(:hello)
  end

  post('/uno') do
    if $game.player.cards_left == 1
      uno = params["uno"]
      if uno == "yes"
        $must_say_uno = "no"
      end
    else
      $game.player.take_cards($game.draw_cards(2))
    end
    redirect("/game")
  end

  post('/join_game') do
    player = params["name"].strip
    if player == ''
      redirect("/")
    else
      $player = player
      $game = nil
      $what_happened = []
      $result = nil
      $must_say_uno = "no"
      $game = Game.new
      redirect("/game")
    end
  end

  get("/game") do
    if $game
      slim(:game)
    else
      redirect("/")
    end
  end

  post("/game") do
    if $must_say_uno == "yes"
      $game.player.take_cards($game.draw_cards(2))
      $result = "You Forgot to say uno"
      $must_say_uno = "no"
      redirect("/game")
    else
      hash = {status: 200}
      if not $game.game_over?
        if params == {}
          json_object = JSON.parse(request.body.read)
          card = json_object["card"].split.map(&:capitalize).join(' ')
        else
          if params["color_request"]
            card = params["color_request"]
          else
            card = params["color"]
          end
        end
        if card.split(" ").length == 1 && $card_to_play != nil
          card_to_play = $card_to_play
          $card_to_play = nil
          color = card
          result = $game.play_a_round(card_to_play, color)
          $message = nil
        else
          if card == "Color Wild"
            $card_to_play = "Color Wild"
            $message = "What Color do You want to change it to?"
            redirect("/game")
            return json hash
          elsif card == "Color Wild Draw Four"
            $card_to_play = "Color Wild Draw Four"
            $message = "What Color do You want to change it to?"
            redirect("/game")
            return json hash
          else
            card_to_play = card
          end
          result = $game.play_a_round(card_to_play)
        end
        $result = result
        if result == "You can't play that" || result == "You can't play that because you don't have it"

          redirect("/game")
          return json hash
        else
          $what_happened.concat($game.bots_turn)
          if $game.player.cards_left == 1
            $must_say_uno = "yes"
          end
          if $game.player.cards_left == 2
            $must_say_uno = "no"
          end
          redirect("/game")
          return json hash
        end
      else
        @winner = $game.game_over?
        redirect("/game")
        return json hash
      end
    end
  end
end
