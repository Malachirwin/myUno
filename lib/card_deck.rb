require_relative 'card'

class CardDeck
  def initialize
    @deck = create_deck
  end

  def create_deck
    colors = ['Red', 'Yellow', 'Green', 'Blue']
    deck = 2.times.map do
      colors.map do |color|
        9.times.map do |number|
          rank = number + 1
          Card.new(color, rank)
        end
      end.flatten
    end
    deck[0] + deck[1]
  end

  def shuffle
    card_deck.shuffle!
  end

  def cards_left
    card_deck.length
  end

  def deal(deck, *players)
    shuffle
    players.each do |player_hand|
      5.times do
        player_hand.player_hand.push(remove_top_card)
      end
    end
    players
  end

  def remove_top_card
    card_deck.shift
  end

  def remove_all_cards_from_deck
    @deck = []
  end

  def has_cards?
    if cards_left > 0
      return true
    end
  end

  private

  def card_deck
    @deck
  end
end
