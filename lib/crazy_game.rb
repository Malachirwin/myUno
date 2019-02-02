require_relative 'player'
require_relative 'card_deck'
require 'pry'

class CrazyGame
  def initialize
    @players = []
    4.times do |index|
      @players << Player.new("player #{index + 1}")
    end
    @player_turn = 0
    @direction = 'Clockwise'
    @deck = CardDeck.new
    @deck.shuffle
    @deck.deal(@deck, *@players)
    @played_cards = []
    @number_of_cards_to_pickup = 0
    card = Card.new("Hello", "I'm not a card")
    until card.rank.class == Integer
      card = deck.remove_top_card
      pervious_cards = @played_cards
      @played_cards = [card]
      deck.add_cards_and_shuffle(pervious_cards)
    end
    players.each do |this_player|
      if this_player.cards_left < 5
        until this_player.cards_left == 5
          this_player.take_cards(draw_cards(1))
        end
      end
    end

  end

  def player_turn
    @player_turn
  end

  def players
    @players
  end

  def deck
    @deck
  end

  def played_cards
    @played_cards
  end

  def set_played_card(card)
    @played_cards = [card]
  end

  def game_over?
    result = ''
    players.each do |player|
      if player.cards_left == 0
        return player
      else
        result = false
      end
    end
    return result
  end

  def player
    players.first
  end

  def play_a_round(card_to_play, color=nil)
    if card_to_play == "Draw"
      card_from_pile = draw_cards(1)
      player.take_cards(card_from_pile)
      next_players_turn
      card_from_pile
    else
      card_to_delete = nil
      if player.cards.include?(card_to_play)
        if card_to_play.split(" ").length == 2
          card_to_delete = regular_card(card_to_play, color)
        elsif card_to_play.split(" ").length == 4 # if true the card is a wild draw four
          card_to_delete = player_draw_four(card_to_play, color)
        else # it is a draw two
          card_to_delete = player_draw_two(card_to_play)
        end
      else
        return "You can't play that because you don't have it"
      end
      reverse(card_to_delete) if card_to_delete != "You can't play that"
      skip(card_to_delete) if card_to_delete != "You can't play that"
      player.player_hand.delete(card_to_delete) if card_to_delete != "You can't play that"
      next_players_turn
      card_to_delete
    end
  end

  def regular_card(card_to_play, color)
    if card_to_play.split(" ")[1] == played_cards.last.rank.to_s || card_to_play.split(" ")[0] == played_cards.last.color || card_to_play.split(" ")[1] == "Wild"
      the_card = nil
      player.player_hand.each do |card|
        if card_to_play == card.value
          the_card = card
        end
      end
      if the_card.rank == "Wild"
        the_card.change_color(color)
      end
      card_to_delete = the_card
      played_cards << the_card
    else
      return "You can't play that"
    end
    card_to_delete
  end

  def player_draw_four(card_to_play, color)
    the_card = nil
    player.player_hand.each do |card|
      if card_to_play == card.value
        the_card = card
      end
    end
    the_card.change_color(color)
    played_cards << the_card
    players[next_player_number].take_cards(draw_cards(4))
    next_players_turn
    card_to_delete = the_card
  end

  def draw_cards(number_of_cards)
    if deck.cards_left <= number_of_cards
      cards = @played_cards.shift(played_cards.length - 1)
      deck.add_cards_and_shuffle(cards)
    end
    cards = []
    number_of_cards.times do
      cards.push(deck.remove_top_card)
    end
    cards
  end

  def player_draw_two(card_to_play)
    if [card_to_play.split(" ")[1], card_to_play.split(" ")[2]].join(" ") == played_cards.last.rank.to_s || card_to_play.split(" ")[0] == played_cards.last.color
      the_card = nil
      player.player_hand.each do |card|
        if card_to_play == card.value
          the_card = card
        end
      end
      card_to_delete = the_card
      players[next_player_number].take_cards(draw_cards(2))
      played_cards << the_card
    else
      return "You can't play that"
    end
    card_to_delete
  end

  def bots_turn
    what_happened = []
    until player_turn == 0
      players[1..3].each.with_index do |playing_player, index|
        if game_over? == false
          card_to_delete = nil
          playing_player.player_hand.each do |card|
            if player_turn == index + 1
              if players[next_player_number].cards_left <= 3 && playing_player.cards.include?("#{played_cards.last.color} Draw Two")
                playing_player.player_hand.each do |card|
                  if card.rank == "Draw Two" && card.color == played_cards.last.color
                    card_to_delete = card
                    draw_two(card)
                    what_happened.push([playing_player.name, card.value])
                    played_cards << card
                    next_players_turn
                  end
                end
              elsif players[next_player_number].cards_left <= 3 && playing_player.cards.include?("Wild Draw Four")
                playing_player.player_hand.each do |card|
                  if card.rank == "Wild Draw Four"
                    card_to_delete = card
                    card = wild_draw_four(card, playing_player)
                    what_happened.push([playing_player.name, card.value])
                    played_cards << card
                    next_players_turn
                  end
                end
              elsif card.rank == played_cards.last.rank.to_s || card.color == played_cards.last.color || card.rank == "Wild Draw Four" || card.rank == "Wild"
                card_to_delete = card
                reverse(card)
                skip(card)
                draw_two(card)
                card = wild(card, playing_player)
                card = wild_draw_four(card, playing_player)
                what_happened.push([playing_player.name, card.value])
                played_cards << card
                next_players_turn
              end
            end
          end
        else
          what_happened.push([game_over?, "winner"])
          playing_player.player_hand.delete(card_to_delete)
          return what_happened
        end
        if card_to_delete
          playing_player.player_hand.delete(card_to_delete)
        else
          if player_turn == index + 1
              playing_player.take_cards(draw_cards(1))
            what_happened.push([playing_player.name, "Drew a card"])
            next_players_turn
          end
        end
      end
    end
    what_happened
  end

  def skip(card)
    if card.rank == "Skip"
      next_players_turn
    end
  end

  def draw_two(card)
    if card.rank == "Draw Two"
      next_player = players[next_player_number]
      next_player.take_cards(draw_cards(2))
      next_players_turn
    end
  end

  def wild_draw_four(card, playing_player)
    if card.rank == "Wild Draw Four"
      players[next_player_number].take_cards(draw_cards(4))
      index = 0
      color = playing_player.player_hand[rand(playing_player.player_hand.length)].color
      until color != "Color" || index == 5
        index += 1
        color = playing_player.player_hand[rand(playing_player.player_hand.length)].color
      end
      if index == 5
        color = ["Red", "Green", "Blue", "Yellow"][rand(0..3)]
      end
      card.change_color(color)
      next_players_turn
    end
    card
  end

  def wild(card, playing_player)
    if card.rank == "Wild"
      index = 0
      color = playing_player.player_hand[rand(playing_player.player_hand.length)].color
      until color != "Color" || index == 5
        index += 1
        color = playing_player.player_hand[rand(playing_player.player_hand.length)].color
      end
      if index == 5
        color = ["Red", "Green", "Blue", "Yellow"][rand(0..3)]
      end
      card.change_color(color)
    end
    card
  end

  def reverse(card)
    if card.rank == "Reverse"
      if direction == "Clockwise"
        @direction = "Counter-Clockwise"
      else
        @direction = "Clockwise"
      end
    end
  end

  def direction
    @direction
  end

  def next_player_number
    if direction == "Clockwise"
      if player_turn == 3
        next_player_number = 0
      else
        next_player_number = player_turn + 1
      end
    else
      if player_turn == 0
        next_player_number = 3
      else
        next_player_number = player_turn - 1
      end
    end
    next_player_number
  end

  def next_players_turn
    if direction == "Clockwise"
      if player_turn == 3
        @player_turn = 0
      else
        @player_turn += 1
      end
    else
      if player_turn == 0
        @player_turn = 3
      else
        @player_turn -= 1
      end
    end
  end
end
