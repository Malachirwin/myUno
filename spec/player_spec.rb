require 'player'
require 'card'
require "json"

describe Player do
  it 'can be created with a list of cards' do
    player = Player.new('name', [Card.new("Red", 1)])
    expect(player.cards_left).to be 1
  end

  it 'can set the cards' do
    cards = [Card.new("Green", 6)]
    player = Player.new('name')
    player.set_hand(cards)
    expect(player.cards_left).to be 1
  end

  it 'returns the number of cards left in the players hand' do
    red6 = Card.new("Red", 6)
    blue3 = Card.new("Blue", 3)
    redskip = Card.new("Red", "Skip")
    player = Player.new("Malachi", [red6, blue3, redskip])
    expect(player.cards_left).to eq 3
  end

  it 'takes cards' do
    player = Player.new('name', [Card.new("Blue", 4), Card.new("Green", "Skip")])
    red6 = Card.new("Red", 6)
    player.take_cards([red6])
    expect(player.player_hand).to include red6
  end

  it 'can be created with a list of cards' do
    player = Player.new('name', [Card.new("Blue", 4), Card.new("Green", "Skip")])
    expect(player.cards).to eq "Blue 4, Green Skip"
  end

  it 'has a name' do
    player = Player.new("Malachi")
    expect(player.name).to eq "Malachi"
  end

  it 'returns the players hand' do
    red6 = Card.new("Red", 6)
    blue3 = Card.new("Blue", 3)
    redskip = Card.new("Red", "Skip")
    player = Player.new("Malachi", [red6, blue3, redskip])
    expect(player.player_hand).to eq [red6, blue3, redskip]
  end

  it 'sorts the players cards' do
    red6 = Card.new("Red", 6)
    blue3 = Card.new("Blue", 3)
    greenskip = Card.new("Green", "Skip")
    yellow5 = Card.new("Yellow", 5)
    wild_draw_four = Card.new("Color", "Wild Draw Four")
    player = Player.new("Malachi", [red6, blue3, greenskip, yellow5, wild_draw_four])
    player.sort_hand()
    expect(player.player_hand).to eq [blue3, greenskip, red6, yellow5, wild_draw_four]
  end
end
