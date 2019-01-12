require '../data/price_rules'
require 'test/unit'

class PriceRulesTest < Test::Unit::TestCase
  def test_products_id_presence
    assert PRICE_RULES.has_key?(:GR1), "Green Tea price rule should be defined"
    assert PRICE_RULES.has_key?(:CF1), "Coffee price rule should be defined"
    assert PRICE_RULES.has_key?(:SR1), "Strawberry price rule should be defined"
  end

  def test_bogof_discount_rule
    rules = PRICE_RULES[:GR1]
    assert_equal rules[:type], :bogof
    assert_equal rules[:size], 2
  end

  def test_regular_discount_rule
    rules = PRICE_RULES[:SR1]
    assert_equal rules[:type], :regular
    assert_equal rules[:size], 3
    assert_equal rules[:amount], 0.5
  end

  def test_regular_percent_discount_rule
    rules = PRICE_RULES[:CF1]
    assert_equal rules[:type], :regular
    assert_equal rules[:size], 3
    assert_equal rules[:amount], 1/3.0
  end
end