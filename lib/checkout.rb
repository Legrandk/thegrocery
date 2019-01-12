require '../data/products'

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
    # noTE: Covert [ :SR1, :SR1, :GR1, :SR1] to {:GR1=>1, :SR1=>3}
    items_grouped = @@items.inject( Hash.new(0)) { |h, prod| h[prod] += 1 ; h } 

    total = 0
    items_grouped.each do |prod_id, amount|
      discount = calculate_discount_for_item( prod_id, amount)

      total += ((amount * PRODUCTS[prod_id][:price]) - discount).round(2)
    end

    total
  end


  private

  def calculate_discount_for_item( prod_id, num_items)
    discount = 0
    price_rule = @@price_rules[prod_id]

    if :bogof == price_rule[:type]
      discount = (num_items / price_rule[:size]) * PRODUCTS[prod_id][:price]
    
    elsif :regular == price_rule[:type]
      if num_items >= price_rule[:size]
        unit_discount = :percent == price_rule[:base] ? PRODUCTS[prod_id][:price] : 1

        discount = (unit_discount * price_rule[:amount]) * num_items
      end
    end

    discount.round(2)
  end
end