require 'card'
require 'rspec'
require 'game'

describe 'Game' do
  it 'expects 4 players in a game' do
    game = Game.new
    expect(game.players.first.name).to eq 'player 1'
    expect(game.players.last.name).to eq 'player 4'
  end

  it 'is not over when it is created' do
    game = Game.new
    expect(game.game_over?).to eq false
  end

  it 'Plays a round with a wild draw four' do
    game = Game.new
    game.player.set_hand([Card.new('Color', 'Wild Draw Four')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Color Wild Draw Four'
  end

  it 'Plays a round with a draw two' do
    game = Game.new
    game.player.set_hand([Card.new('Red', 'Draw Two')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Red Draw Two'
  end

  it 'Plays a round with a skip' do
    game = Game.new
    game.player.set_hand([Card.new('Green', 'Skip')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Green Skip'
  end

  it 'Plays a round with a reverse' do
    game = Game.new
    game.player.set_hand([Card.new('Yellow', 'Reverse')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Yellow Reverse'
  end

  it 'Plays a round with a a regular card' do
    game = Game.new
    game.player.set_hand([Card.new('Blue', 5)])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Blue 5'
  end

  it 'is over when someone has no cards' do
    game = Game.new
    game.players.first.set_hand []
    expect(game.game_over?).to_not eq false
  end
end
