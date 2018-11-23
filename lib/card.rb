class Card
  def initialize(color, rank)
    @color = color
    @rank = rank
  end

  def rank
    @rank
  end

  def to_img_path
    if @rank.class == Integer
      "#{@color[0].downcase}#{@rank}.jpg"
    else
      if @rank == "Wild"
        "wild.jpg"
      elsif @rank == "Wild Draw Four"
        "w+4.jpg"
      elsif @rank == "Draw Two"
        "#{@color[0].downcase}+2.jpg"
      elsif @rank == "Reverse"
        "#{@color[0].downcase}r.jpg"
      elsif @rank == "Skip"
        "#{@color[0].downcase}s.jpg"
      end
    end
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

  def card_value
    if color != "Color"
      "#{color} #{rank}"
    else
      rank
    end
  end
end
