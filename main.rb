# frozen_string_literal: true

require 'dotenv/load'
require 'telegram/bot'

require_relative 'lib/game'

token = ENV['TELEGRAM_TOKEN']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      greetings_message = <<~END
        Добро пожаловать в карточную игру "Пьяница", #{message.from.first_name}!
        Для запуска игры наберите /play;
        Для просмотра очков наберите /score.
      END
      bot.api.send_message(chat_id: message.chat.id, text: greetings_message)
    when '/play'
      bot.api.send_message(chat_id: message.chat.id, text: 'Раздаю карты...')
      sleep(1)
      bot.api.send_message(chat_id: message.chat.id, text: 'На самом деле игра очень простая, поэтому вы увидите только результат :)')
      sleep(1)
      bot.api.send_message(chat_id: message.chat.id, text: 'Играем!!!')
      game = Game.new(bot, message)
      game.play
    when '/score'
      bot.api.send_message(chat_id: message.chat.id, text: Game.score(message.from.id))
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Пока, #{message.from.first_name}, спасибо за игру!")
    end
  end
end
