require_relative 'player'
require_relative 'card_deck'
require 'pry'

class Game
  def initialize
    @players = []
    4.times do |index|
      @players << Player.new("player #{index + 1}")
    end
    @deck = CardDeck.new
    @deck.shuffle
    @deck.deal(@deck, *@players)
    @played_cards = [deck.remove_top_card]

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

  def set_played_card(card)
    @played_cards = [card]
  end

  def play_a_round(card_to_play)
    card_to_delete = nil
    if player.cards.include?(card_to_play)
      if card_to_play.split(" ").length == 2
        card_to_delete = regular_card(card_to_play)
      elsif card_to_play.split(" ").length == 4 # if true the card is a wild draw four
        card_to_delete = draw_four(card_to_play)
      else # it is a draw two
        card_to_delete = draw_two(card_to_play)
      end
    else
      return "You can't play that because you don't have it"
    end
    player.player_hand.delete(card_to_delete) if card_to_delete != "You can't play that"
    card_to_delete
  end

  def regular_card(card_to_play)
    if card_to_play.split(" ")[1] == played_cards.last.rank.to_s || card_to_play.split(" ")[0] == played_cards.last.color
      the_card = nil
      player.player_hand.each do |card|
        if card_to_play == card.value
          the_card = card
        end
      end
      card_to_delete = the_card
      played_cards << the_card
    else
      return "You can't play that"
    end
    card_to_delete
  end

  def draw_four(card_to_play)
    the_card = nil
    player.player_hand.each do |card|
      if card_to_play == card.value
        the_card = card
      end
    end
    played_cards << the_card
    card_to_delete = the_card
  end

  def draw_two(card_to_play)
    if [card_to_play.split(" ")[1], card_to_play.split(" ")[2]].join(" ") == played_cards.last.rank.to_s || card_to_play.split(" ")[0] == played_cards.last.color
      the_card = nil
      player.player_hand.each do |card|
        if card_to_play == card.value
          the_card = card
        end
      end
      card_to_delete = the_card
      played_cards << the_card
    else
      return "You can't play that"
    end
    card_to_delete
  end

  # player_turn = 1
  # players[1..3].each.with_index do |player, index|
  #   player.player_hand.each do |card|
  #     if player_turn - 1 == index
  #       if card.rank == played_cards.last.rank || card.color == played_cards.last.color
  #         card_to_delete = card
  #         played_cards << card
  #         player_turn += 1
  #       end
  #     end
  #   end
  # end
end

  # def play(hand_1, played_card)
  #   hand_1.each do |element|
  #     if element.to_i == played_card.last.to_i
  #       playing_card = element
  #       puts playing_card
  #       hand_1 -= [element]
  #       played_card << element
  #       return [hand_1, played_card]
  #     end
  #     if element.length == played_card.last.length
  #       playing_card = element
  #       puts playing_card
  #       hand_1 -= [element]
  #       played_card << element
  #       return [hand_1, played_card]
  #     end
  #   end
  # end
  # while players_hand.length > 0 || hand_1.length > 0
  #   puts 'this is your hand'
  #   puts players_hand.join ' '
  #   puts hand_1.join ' '
  #   playing_card = gets.chomp.downcase
  #   if playing_card == 'draw'
  #     cards -= [cards.first]
  #     players_hand << cards.first
  #     hand_1, played_card = play(hand_1, played_card)
  #   end
  #   if playing_card.to_i == played_card.last.to_i
  #     players_hand -= [playing_card]
  #     played_card << playing_card
  #       hand_1.each do |element|
  #       if element.to_i == played_card.last.to_i
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #       if element.length == played_card.last.length
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #     end
  #   end
  #   if playing_card.length == played_card.last.length
  #     players_hand -= [playing_card]
  #     played_card << playing_card
  #     hand_1.each do |element|
  #       if element.to_i == played_card.last.to_i
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #       if element.length == played_card.last.length
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #     end
  #   end
  #   if playing_card == 'wild'
  #     play_card = gets.chomp
  #     players_hand -= [playing_card]
  #     played_card << playing_card
  #     players_hand -= [play_card]
  #     played_card << play_card
  #     hand_1.each do |element|
  #       if element.to_i == played_card.last.to_i
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #       if element.length == played_card.last.length
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #     end
  #   end
  #   if playing_card == '+2green' || playing_card == '+2red' || playing_card == '+2blue'
  #     2.times do
  #       cards -= [cards.first]
  #       hand_1 << cards.first
  #     end
  #     hand_1.each do |element|
  #       if element.to_i == played_card.last.to_i
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #       if element.length == played_card.last.length
  #         playing_card = element
  #         puts playing_card
  #         hand_1 -= [element]
  #         played_card << element
  #       end
  #     end
  #   end
  # end
  # puts 'thanks for playing!'
