# frozen_string_literal: true

require 'json'
require_relative 'card'

class Deck
  SUITS = %w[♠ ♥ ♦ ♣].freeze

  attr_reader :cards_in_deck

  def initialize
    @cards_in_deck = []
    cards = JSON.parse(File.read("#{__dir__}/../data/cards.json"))
    cards.each do |card|
      SUITS.each do |suit|
        @cards_in_deck << Card.new(value: card.last['symbol'],
                                   weight: card.last['weight'],
                                   suit: suit)
      end
    end
  end

  def shuffle
    @cards_in_deck.shuffle!
    self
  end

  def hand_out(player1, player2)
    while @cards_in_deck.any?
      player1.cards << @cards_in_deck.pop
      player2.cards << @cards_in_deck.pop
    end
  end
end
