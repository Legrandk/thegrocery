CURRENCY = "£"

PRODUCTS = {
  :GR1 => {
    :name => "Green Tea",
    :price => 3.11
  },

  :SR1 => {
    :name => "Strawberries",
    :price => 5.00
  },

  :CF1 => {
    :name => "Coffee",
    :price => 11.23
  },
}

# PRODUCTS = [
#   [:GR1, "Green Tea", 3.11],
#   [:SR1, "Strawberries", 5.00],
#   [:CF1, "Coffee", 11.23]
# ]

PRICE_RULES = {
  :GR1 => {
    :type => :bogof,
    :size => 2
  },

  :SR1 => {
    :type => :regular,
    :size => 3,
    :amount => 0.5,
    :base => :unit
  },

  :CF1 => {
    :type => :regular,
    :size => 3,
    :amount => 2/3.0,
    :base => :percent
  },
}


# PRICE_RULES = [
#   { 
#     :id => :BOGOF_CEO,
#     :prod => :GR1,
#     :type => :BOGOF,
#     :pack_size => 2
#   },
#   { 
#     :id => :SR_COO,
#     :prod => :SR1,
#     :type => :REG,
#     :min_size => 3,
#     :amout => 0.5,
#     :unit => :currency
#   },
#   { 
#     :id => :BOGOF_CEO,
#     :prod => :CF1,
#     :type => :REG,
#     :min_size => 3,
#     :amout => 0.5,
#     :unit => :percentage,
#   },

# ]

def get_price_rule_for_product( prod_id)
  PRICE_RULES[ prod_id]
end

def get_product_price( prod_id)
  PRODUCTS[prod_id][:price]
end

def calculate_discount_for_item( prod_id, num_items, price_rule)
  #{:type=>:bogof, :size=>2}
  #{:type=>:regular, :size=>3, :amount=>0.5, :units=>:currency}
  #{:type=>:regular, :size=>3, :amount=>0.5, :units=>:percentage}

  discount = 0
  if :bogof == price_rule[:type]
    discount = (num_items / price_rule[:size]) * get_product_price( prod_id)
  elsif :regular == price_rule[:type]
    if num_items >= price_rule[:size]
      if :unit == price_rule[:base]
        discount = price_rule[:amount]
      elsif :percent == price_rule[:base]
        discount = get_product_price( prod_id) - get_product_price( prod_id) * price_rule[:amount]
      end
        discount *= num_items
    end
  end

  discount.round(2)
end


puts ">> The Grocery <<"


BASKET = [ :GR1, :SR1, :GR1, :GR1, :CF1]
# BASKET = [ :GR1, :GR1]
# BASKET = [ :SR1, :SR1, :GR1, :SR1]
# BASKET = [ :GR1, :CF1, :SR1, :CF1, :CF1]

items_grouped = BASKET.inject( Hash.new(0)) { |h, prod| h[prod] += 1 ; h } 

puts "Basket: #{items_grouped}" #{:GR1=>3, :SR1=>1, :CF1=>1}

total = 0
items_grouped.each do |prod_id, amount|
  # puts "Item: #{k} Units: #{v} Price rule: #{get_price_rule_for_product(k)}"

  discount = calculate_discount_for_item( prod_id, amount, get_price_rule_for_product(prod_id))

  print "* '#{PRODUCTS[prod_id][:name]}(#{prod_id} )':\t#{amount} x #{PRODUCTS[prod_id][:price]} = "
  print "#{amount * PRODUCTS[prod_id][:price]} - #{discount} = "
  puts  "#{((amount * PRODUCTS[prod_id][:price]) - discount).round(2)}"

  total += ((amount * PRODUCTS[prod_id][:price]) - discount).round(2)
end

puts "Total: #{total} #{CURRENCY}"



