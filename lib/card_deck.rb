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
    special_deck = 2.times.map do
      [Card.new('Red', 'Reverse'), Card.new('Blue', 'Reverse'), Card.new('Green', 'Reverse'), Card.new('Yellow', 'Reverse'), Card.new('Red', 'Skip'), Card.new('Blue', 'Skip'), Card.new('Green', 'Skip'), Card.new('Yellow', 'Skip'), Card.new('Red', 'Draw two'), Card.new('Blue', 'Draw two'), Card.new('Green', 'Draw two'), Card.new('Yellow', 'Draw two'), Card.new('Color', 'Wild Draw Four'), Card.new('Color', 'Wild Draw Four'), Card.new('Color', 'Wild'), Card.new('Color', 'Wild')]
    end.flatten
    deck[0] + deck[1] + special_deck
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
