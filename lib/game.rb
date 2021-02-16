# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'

class Game
  def initialize(bot, message)
    @bot = bot
    @message = message
    @player1 = Player.find_or_create(message.from.id, message.from.first_name)
    @player2 = Player.new(0, 'DrunkardGoodBot', 0, 0)
    @deck = Deck.new.shuffle
    @game_log = []

    @deck.hand_out(@player1, @player2)
  end

  def play
    cards_on_table = []

    while @player1.cards.any? && @player2.cards.any?
      player1_card = @player1.card_on_table
      player2_card = @player2.card_on_table

      cards_on_table << player1_card << player2_card

      write_to_log("Игрок #{@player1} положил карту: #{player1_card}")
      write_to_log("Игрок #{@player2} положил карту: #{player2_card}")

      if player1_card > player2_card
        cards_on_table = take_cards(@player1, cards_on_table)
      elsif player1_card < player2_card
        cards_on_table = take_cards(@player2, cards_on_table)
      else
        write_to_log('Карты равны.')
      end

      write_to_log("\n#{'=' * 30}\n")
    end

    if @player1.cards.empty?
      write_to_log("Победил #{@player2}")
      @player1.bot_score = @player1.bot_score + 1
    else
      write_to_log("Победил #{@player1}")
      @player1.score = @player1.score + 1
    end

    @player1.update
    write_to_log("Общий счёт:\nБот:#{@player1.bot_score}\nИгрок: #{@player1.score}")
    send_log(@game_log)
  end

  def send_log(log)
    if log.join("\n").length >= 4096
      log1 = log[0...log.size / 2]
      log2 = log[log.size / 2..log.size]
      send_log(log1)
      send_log(log2)
    else
      @bot.api.send_message(chat_id: @message.chat.id, text: log.join("\n"))
    end
  end

  def take_cards(player, cards_on_table)
    player.cards += cards_on_table
    write_to_log("Сильнее карта у #{player}")
    []
  end

  def write_to_log(text)
    @game_log << text
  end

  def self.score(id)
    db = Database.new
    score = db.score(id)
    bot_score = score[0]
    user_score = score[1]
    "Общий счёт:\nБот:#{bot_score}\nИгрок: #{user_score}"
  end
end
