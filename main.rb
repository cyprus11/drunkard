require_relative 'lib/player'
require_relative 'lib/deck'
require 'dotenv/load'

puts "Добро пожаловать в карточную игру 'Пьяница'. Вожалуйста, введите ваше имя"

user_name = STDIN.gets.chomp

player1 = Player.new(user_name)
player2 = Player.new('Компьютер')
deck = Deck.new.shuffle

deck.hand_out(player1, player2)

while player1.cards.any? && player2.cards.any?
  player1_card = player1.card_on_table
  player2_card = player2.card_on_table

  puts "Игрок #{player1} положил карту: #{player1_card}"
  puts "Игрок #{player2} положил карту: #{player2_card}"

  if player1_card.weight > player2_card.weight
    player1.cards += [player2_card, player1_card]
    puts "Сильнее карта у #{player1}"
  elsif player1_card.weight < player2_card.weight
    player2.cards += [player1_card, player2_card]
    puts "Сильнее карта у #{player2}"
  else
    if player1.cards.any? && player2.cards.any?
      cards_on_table = [player1_card, player2_card]
      unless cards_on_table.nil?
        player1_card = player1.card_on_table
        player2_card = player2.card_on_table

        puts "Игрок #{player1} положил карту: #{player1_card}"
        puts "Игрок #{player2} положил карту: #{player2_card}"

        if player1_card.weight > player2_card.weight
          player1.cards += cards_on_table + [player2_card, player1_card]
          puts "Сильнее карта у #{player1}"
          cards_on_table = nil
        elsif player1_card.weight < player2_card.weight
          player2.cards += cards_on_table + [player1_card, player2_card]
          puts "Сильнее карта у #{player2}"
          cards_on_table = nil
        else
          cards_on_table += [player1_card, player2_card]
        end
      end
    end
  end
end

if player1.cards.empty?
  puts "Победил #{player1}"
else
  puts "Победил #{player1}"
end
