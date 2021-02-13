require_relative 'player'
require_relative 'deck'

class Game
  def initialize(bot, message)
    @bot = bot
    @message = message
    @player1 = Player.new(message.from.first_name)
    @player2 = Player.new('DrunkardGoodBot')
    @deck = Deck.new.shuffle
    @game_log = ''

    @deck.hand_out(@player1, @player2)
  end

  def play
    while @player1.cards.any? && @player2.cards.any?
      player1_card = @player1.card_on_table
      player2_card = @player2.card_on_table

      write_to_log("Игрок #{@player1} положил карту: #{player1_card}")
      write_to_log("Игрок #{@player2} положил карту: #{player2_card}")

      if player1_card.weight > player2_card.weight
        @player1.cards += [player2_card, player1_card]
        write_to_log("Сильнее карта у #{@player1}")
      elsif player1_card.weight < player2_card.weight
        @player2.cards += [player1_card, player2_card]
        write_to_log("Сильнее карта у #{@player2}")
      else
        if @player1.cards.any? && @player2.cards.any?
          cards_on_table = [player1_card, player2_card]
          unless cards_on_table.nil?
            player1_card = @player1.card_on_table
            player2_card = @player2.card_on_table

            write_to_log("Игрок #{@player1} положил карту: #{player1_card}")
            write_to_log("Игрок #{@player2} положил карту: #{player2_card}")

            if player1_card.weight > player2_card.weight
              @player1.cards += cards_on_table + [player2_card, player1_card]
              write_to_log("Сильнее карта у #{@player1}")
              cards_on_table = nil
            elsif player1_card.weight < player2_card.weight
              @player2.cards += cards_on_table + [player1_card, player2_card]
              write_to_log("Сильнее карта у #{@player2}")
              cards_on_table = nil
            else
              cards_on_table += [player1_card, player2_card]
            end
          end
        end
      end
    end

    if @player1.cards.empty?
      write_to_log("Победил #{@player2}")
    else
      write_to_log("Победил #{@player1}")
    end

    send_message(@game_log)
  end

  def send_message(text)
    @bot.api.send_message(chat_id: @message.chat.id, text: text)
  end

  def write_to_log(text)
    @game_log += text + "\n"
  end

end
