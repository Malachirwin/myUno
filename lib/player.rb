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

  def sort_hand()
    red = []
    green = []
    yellow = []
    blue = []
    wild = []
    player_hand.each do |card|
      if card.color == "Yellow"
        yellow.push(card)
      elsif card.color == "Blue"
        blue.push(card)
      elsif card.color == "Red"
        red.push(card)
      elsif card.color == "Green"
        green.push(card)
      elsif card.color == "Color" # wild's color is "Color"
        wild.push(card)
      end
    end
    @cards = blue.concat(green).concat(red).concat(yellow).concat(wild)
  end

  def cards_left
    player_hand.count
  end

  def take_cards(cards)
    @cards.push(*cards)
  end
  
  def cards
    result = []
    player_hand.each do |card|
      result.push(card.value)
    end
    result.join(", ")
  end

  def set_hand(cards)
    @cards = *cards
  end
end
