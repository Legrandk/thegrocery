require 'singleton'
require 'yaml'

require 'lib/utils'

class PricingRules
  include Singleton
  include Utils

  def initialize
    @@rules = symbolize_keys( YAML.load_file('data/price_rules.yml'))
  end

  def rule_for( product_id)
    return @@rules[ product_id]
  end

  def price_discount_for( product_id, unit_price, num_items)
    discount = 0

    return discount if @@rules[product_id].nil?

    case @@rules[product_id][:type]
    when :bogof
      discount = get_bogof_discount_for( unit_price, num_items, @@rules[product_id][:size])

    when :absolute
      discount = get_absolute_discount_for(unit_price, num_items, @@rules[product_id][:amount], @@rules[product_id][:size])

    when :percent
      discount = get_percent_discount_for(unit_price, num_items, @@rules[product_id][:amount], @@rules[product_id][:size])
    end

    discount.round(2)
  end


  private

  def get_bogof_discount_for(unit_price, num_items, size = 2)
    (num_items / size) * unit_price
  end

  def get_absolute_discount_for(unit_price, num_items, amount, min_size)
    min_size <= num_items ? amount * num_items : 0
  end

  def get_percent_discount_for(unit_price, num_items, amount, min_size)
    min_size <= num_items ? (unit_price * (amount*0.01)) * num_items : 0
  end

end