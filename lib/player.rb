require "json"
class Player
  def initialize(name, cards=[])
    @cards = cards
    @name = name
  end

  def player_hand
    @cards
  end

  def name
    @name
  end

  def cards_left
    player_hand.count
  end

  def set_hand(cards)
    @cards = *cards
  end
end
