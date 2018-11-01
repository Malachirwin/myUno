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
end
