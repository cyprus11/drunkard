# frozen_string_literal: true

class Card
  include Comparable

  attr_reader :value, :weight

  def initialize(args)
    @value = args[:value]
    @weight = args[:weight]
    @suit = args[:suit]
  end

  def <=>(other)
    return -1 if value == 'A' && other.value == '6'
    return 1 if value == '6' && other.value == 'A'

    weight <=> other.weight
  end

  def to_s
    "#{value}#{@suit}"
  end
end
