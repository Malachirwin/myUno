require 'player'
require 'card'
require "json"

describe Player do
  it 'can be created with a list of cards' do
    cards = [Card.new("S", 1)]
    player = Player.new('name', cards)
    expect(player.cards_left).to be 1
  end
end
