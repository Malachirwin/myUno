class GameHolder
  def initialize(game: , player_name:)
    @data = {game: game, player_name: player_name, result: nil, what_happened: [], must_say_uno: "no", round: 1, message: nil, wild_card_holder: nil}
  end

  def data
    @data
  end

  def game
    data[:game]
  end

  def player_name
    data[:player_name]
  end

  def wild_card_holder
    data[:wild_card_holder]
  end

  def set_wild_card_holder(card)
    @data[:wild_card_holder] = card
  end

  def reset_wild_card_holder
    @data[:wild_card_holder] = nil
  end

  def result
    data[:result]
  end

  def message
    data[:message]
  end

  def change_message(new_message)
    @data[:message] = new_message
  end

  def reset_message
    @data[:message] = nil
  end

  def change_result(result)
    @data[:result] = result
  end

  def what_happened
    data[:what_happened]
  end

  def add_what_happened(result)
    @data[:what_happened].concat(result)
  end

  def must_say_uno
    data[:must_say_uno]
  end

  def player_needs_to_say_uno
    @data[:must_say_uno] = "yes"
  end

  def player_said_uno
    @data[:must_say_uno] = "no"
  end

  def round
    data[:round]
  end

  def increase_round
    @data[:round] += 1
  end
end
