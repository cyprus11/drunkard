class Card
  attr_reader :value, :weight

  def initialize(args)
    @value = args[:value]
    @weight = args[:weight]
    @suit = args[:suit]
  end

  def to_s
    "#{@value}#{@suit}"
  end
end
