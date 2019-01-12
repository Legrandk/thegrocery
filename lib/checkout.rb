require 'lib/pricing_rules'
require 'lib/utils'

class Checkout
  include Utils

  def initialize( pricing_rules)
    @@products = symbolize_keys( YAML.load_file('data/products.yml'))

    @@pricing_rules = pricing_rules

    @@items = []
  end

  def scan( item_id)
    @@items << item_id
    @@items.count
  end

  def total
    # noTE: Covert [ :SR1, :SR1, :GR1, :SR1] to {:GR1=>1, :SR1=>3}
    items_grouped = @@items.inject( Hash.new(0)) { |h, prod| h[prod] += 1 ; h } 

    items_grouped.reduce(0) do |sum, (prod_id, amount)|
      discount = @@pricing_rules.price_discount_for( prod_id, @@products[prod_id][:price], amount)

      sum + ((amount * @@products[prod_id][:price]) - discount).round(2)
    end
  end
end