class Player
  attr_accessor :cards, :score, :bot_score

  def initialize(user_id, name, score, bot_score)
    @name = name
    @user_id = user_id
    @score = score
    @bot_score = bot_score
    @cards = []
  end

  def user_id
    @user_id
  end

  def card_on_table
    @cards.delete_at(0)
  end

  def to_s
    @name
  end
end
