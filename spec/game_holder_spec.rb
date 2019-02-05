require 'game_holder'
require 'game'
require 'rspec'
require 'crazy_game'

describe 'GameHolder' do
  before do
    @gameholder = GameHolder.new(game: Game.new, player_name: "Malachi")
  end

  it 'holds a game and all the other things needed for the game in a hash' do
    expect(@gameholder.data.class).to eq Hash
  end

  it 'returns a game' do
    expect(@gameholder.game.class).to eq Game
  end

  it "returns a player's name" do
    expect(@gameholder.player_name).to eq "Malachi"
  end

  it 'starts wild card holder as nil' do
    expect(@gameholder.wild_card_holder).to eq nil
  end

  it 'can set wild card holder' do
    @gameholder.set_wild_card_holder("Wild Draw Four")
    expect(@gameholder.wild_card_holder).to eq "Wild Draw Four"
  end

  it 'can reset wild card holder' do
    @gameholder.set_wild_card_holder("Wild Draw Four")
    expect(@gameholder.wild_card_holder).to eq "Wild Draw Four"
    @gameholder.reset_wild_card_holder
    expect(@gameholder.wild_card_holder).to eq nil
  end

  it "starts the result as nil" do
    expect(@gameholder.result).to eq nil
  end

  it "can change the result" do
    @gameholder.change_result("You drew a Red 7")
    expect(@gameholder.result).to eq "You drew a Red 7"
  end

  it 'starts message as nil' do
    expect(@gameholder.message).to eq nil
  end

  it 'can change the message' do
    @gameholder.change_message("It is your turn")
    expect(@gameholder.message).to eq "It is your turn"
  end

  it 'can reset the message' do
    @gameholder.change_message("It is your turn")
    expect(@gameholder.message).to eq "It is your turn"
    @gameholder.reset_message
    expect(@gameholder.message).to eq nil
  end

  it "returns what_happened in an array" do
    expect(@gameholder.what_happened.class).to eq Array
  end

  it 'can add stuff to the array' do
    @gameholder.add_what_happened([["player 1", "Played a Green 4"], ["player 2", "Played a Yellow 4"]])
    expect(@gameholder.what_happened).to eq [["player 1", "Played a Green 4"], ["player 2", "Played a Yellow 4"]]
  end

  it "starts with the player not needing to say uno" do
    expect(@gameholder.must_say_uno).to eq "no"
  end

  it 'can change if a player needs to say uno' do
    @gameholder.player_needs_to_say_uno
    expect(@gameholder.must_say_uno).to eq "yes"
    @gameholder.player_said_uno
    expect(@gameholder.must_say_uno).to eq "no"
  end

  it "starts at round 1" do
    expect(@gameholder.round).to eq 1
  end

  it "Increases the round" do
    @gameholder.increase_round
    expect(@gameholder.round).to eq 2
  end
end
