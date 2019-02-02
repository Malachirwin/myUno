require 'card'
require 'rspec'
require 'crazy_game'

describe 'CrazyGame' do
  it 'expects 4 players in a game' do
    game = CrazyGame.new
    expect(game.players.first.name).to eq 'player 1'
    expect(game.players.last.name).to eq 'player 4'
  end

  it 'expects that you can ask for the player 1' do
    game = CrazyGame.new
    expect(game.player.name).to eq 'player 1'
  end

  it 'expects that it is the first players turn' do
    game = CrazyGame.new
    expect(game.player_turn).to eq 0
  end

  it 'expects that the game deals 5 cards to 4 players and one in the played_cards' do
    game = CrazyGame.new
    expect(game.deck.cards_left).to eq 83
  end

  it 'expects that you can set the played_cards and ask what are all the cards in the pile' do
    game = CrazyGame.new
    blue3 = Card.new("Blue", 3)
    game.set_played_card(blue3)
    expect(game.played_cards).to eq [blue3]
  end

  it 'is not over when it is created' do
    game = CrazyGame.new
    expect(game.game_over?).to eq false
  end

  it 'Plays a round with a wild draw four' do
    game = CrazyGame.new
    wild_four = Card.new('Color', 'Wild Draw Four')
    game.player.set_hand([wild_four])
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Color Wild Draw Four'
    expect(game.players[1].cards_left).to eq 9
    expect(game.played_cards).to include wild_four
  end

  it 'Plays a round with a draw two' do
    game = CrazyGame.new
    game.player.set_hand([Card.new('Red', 'Draw Two')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Red Draw Two'
    expect(game.players[1].cards_left).to eq 7
  end

  it 'Plays a round with a skip' do
    game = CrazyGame.new
    game.player.set_hand([Card.new('Green', 'Skip')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Green Skip'
    expect(game.players[game.player_turn].name).to eq 'player 3'
  end

  it 'expects that you can ask which direction the game is going' do
    game = CrazyGame.new
    expect(game.direction).to eq "Clockwise"
  end

  it 'Plays a round with a reverse' do
    game = CrazyGame.new
    game.player.set_hand([Card.new('Yellow', 'Reverse')])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Yellow Reverse'
    expect(game.players[game.player_turn].name).to eq 'player 4'
  end

  it 'Plays a round with a a regular card' do
    game = CrazyGame.new
    game.player.set_hand([Card.new('Blue', 5)])
    game.set_played_card(game.player.player_hand.first)
    game.play_a_round(game.player.player_hand.first.value)
    expect(game.player.cards).to_not include 'Blue 5'
  end

  it 'is over when someone has no cards' do
    game = CrazyGame.new
    game.players.first.set_hand []
    expect(game.game_over?).to_not eq false
  end

  it 'Plays a round with the bots' do
    game = CrazyGame.new
    game.next_players_turn
    game.players[1..3].each.with_index { |p, i| p.set_hand([Card.new("Blue", (i + rand(1..4))), Card.new("Blue", (i + rand(1..4)))])}
    expect(game.players[1].cards_left).to eq 2
    expect(game.players[2].cards_left).to eq 2
    expect(game.players[3].cards_left).to eq 2
    game.set_played_card(Card.new("Blue", 4))
    game.bots_turn
    expect(game.players[1].cards_left).to eq 1
    expect(game.players[2].cards_left).to eq 1
    expect(game.players[3].cards_left).to eq 1
  end

  it 'a bot plays a wild' do
    game = CrazyGame.new
    game.next_players_turn
    game.players[1].set_hand([Card.new("Color", "Wild"), Card.new("Red", 3)])
    game.players[2].set_hand([Card.new("Red", 4), Card.new("Red", 7)])
    game.players[3].set_hand([Card.new("Red", 2), Card.new("Red", 5)])
    expect(game.players[1].cards_left).to eq 2
    game.set_played_card(Card.new("Blue", 4))
    game.bots_turn
    expect(game.players[1].cards_left).to eq 1
  end

  it 'a bot plays draw two' do
    game = CrazyGame.new
    game.next_players_turn
    game.players[1].set_hand([Card.new("Blue", "Draw Two")])
    game.players[2].set_hand [Card.new("Blue", 4)]
    expect(game.players[1].cards_left).to eq 1
    game.set_played_card(Card.new("Blue", 4))
    game.bots_turn
    expect(game.players[1].cards_left).to eq 0
    expect(game.players[2].cards_left).to eq 3
  end

  it 'a bot plays skip' do
    game = CrazyGame.new
    game.next_players_turn
    game.players[1].set_hand([Card.new("Blue", "Skip")])
    expect(game.players[1].cards_left).to eq 1
    game.set_played_card(Card.new("Blue", 4))
    game.bots_turn
    expect(game.players[1].cards_left).to eq 0
    expect(game.players[2].cards_left).to eq 5
  end
end
