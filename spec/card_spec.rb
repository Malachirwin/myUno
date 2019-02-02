require 'rspec'
require 'card'

describe 'Card' do
  it 'returns the color' do
    card = Card.new('Red', 1)
    expect(card.color).to eq 'Red'
  end

  it 'returns the rank' do
    card = Card.new('Blue', 1)
    expect(card.rank).to eq 1
  end

  it 'returns a card value' do
    card = Card.new('Green', 4)
    expect(card.value).to eq "Green 4"
  end

  it 'returns the correct card value for wilds' do
    card = Card.new('Color', 'Wild')
    expect(card.card_value).to eq "Wild"
  end

  it 'takes a card and returns a image path' do
    card = Card.new('Green', 4)
    expect(card.to_img_path).to eq "g4.jpg"
  end

  it 'can change the color of a card' do
    card = Card.new('Green', 4)
    card.change_color("Red")
    expect(card.color).to eq "Red"
  end
end
