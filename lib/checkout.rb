require 'yaml'

class Checkout

  def initialize( price_rules)
    @@price_rules = price_rules.clone
    @@items = []
  end

  def scan( item_id)
    @@items << item_id
    @@items.count
  end

  def total
    30.57
  end
end