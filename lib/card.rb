class Card
  def initialize(color, rank)
    @color = color
    @rank = rank
  end

  def rank
    @rank
  end

  def color
    @color
  end

  def change_color(color)
    @color = color
  end

  def value
    "#{color} #{rank}"
  end
end
