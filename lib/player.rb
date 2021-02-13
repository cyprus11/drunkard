class Player
  attr_accessor :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def card_on_table
    @cards.delete_at(0)
  end

  def to_s
    @name
  end
end
