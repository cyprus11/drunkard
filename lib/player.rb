# frozen_string_literal: true

require_relative 'database'

class Player
  attr_accessor :cards, :score, :bot_score

  def initialize(user_id, name, score, bot_score)
    @name = name
    @user_id = user_id
    @score = score
    @bot_score = bot_score
    @cards = []
  end

  attr_reader :user_id

  def card_on_table
    @cards.delete_at(0)
  end

  def self.find_or_create(id, name)
    db = Database.new
    db.find_or_create_player(id, name)
  end

  def update
    db = Database.new
    db.update_info(self)
  end

  def to_s
    @name
  end
end
