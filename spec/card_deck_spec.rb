require 'rspec'
require 'card_deck'
require 'pry'
require 'player'

describe "CardDeck" do
  it 'should have 104 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 104
  end

  it 'should deal cards to players' do
    deck = CardDeck.new
    player1 = Player.new("player1")
    player2 = Player.new("player2")
    deck.deal(deck, player1, player2)
    expect(player1.cards_left).to eq 5
    expect(player2.cards_left).to eq 5
  end

  it 'returns true if deck has cards' do
    deck = CardDeck.new
    expect(deck.has_cards?).to eq true
  end

  it 'readds cards to the deck and resets cards value' do
    deck = CardDeck.new
    deck.remove_all_cards_from_deck
    red_wild = Card.new("Red", "Wild")
    blue_wild_draw_four = Card.new("Blue", "Wild Draw Four")
    deck.add_cards_and_shuffle([blue_wild_draw_four, red_wild])
    expect(blue_wild_draw_four.color).to eq "Color"
    expect(red_wild.color).to eq "Color"
  end
end
