require '../lib/pricing_rules'
require 'test/unit'

class PriceRulesTest < Test::Unit::TestCase

  def test_rules_presence_for_products
    rules = PricingRules.instance

    assert_kind_of Hash, rules.rule_for(:GR1)
    assert_kind_of Hash, rules.rule_for(:CF1)
    assert_kind_of Hash, rules.rule_for(:SR1)
  end

  def test_bogof_discount_rule_definition
    rules = PricingRules.instance.rule_for(:GR1)

    assert_equal rules[:type], :bogof
    assert rules[:size] > 1 unless rules[:size].nil?
  end

  def test_absolute_discount_rule_definition
    rules = PricingRules.instance.rule_for(:SR1)

    assert_equal rules[:type], :absolute
    assert_equal rules[:amount], 0.5
    assert rules[:size] > 1
  end

  def test_percent_discount_rule_definition
    rules = PricingRules.instance.rule_for(:CF1)

    assert_equal rules[:type], :percent
    assert_equal rules[:amount], 33.33
    assert rules[:size] > 1
  end

  def test_discout_for_nonexistent_product_should_be_zero
    rules = PricingRules.instance

    assert_equal 0, rules.price_discount_for( :NON_EXISITENT_PRODUCT_ID, 1, 1.0)
  end

  def test_bogof_discount
    rules = PricingRules.instance

    assert_equal 0, rules.price_discount_for( :GR1, 1, 0)
    assert_equal 0, rules.price_discount_for( :GR1, 1, 1)
    assert_equal 1, rules.price_discount_for( :GR1, 1, 2)
    assert_equal 1, rules.price_discount_for( :GR1, 1, 3)
    assert_equal 2, rules.price_discount_for( :GR1, 1, 4)
    assert_equal 2, rules.price_discount_for( :GR1, 1, 5)
  end

  def test_absolute_discount
    rules = PricingRules.instance

    assert_equal 0, rules.price_discount_for( :SR1, 1, 0)
    assert_equal 0, rules.price_discount_for( :SR1, 1, 2)
    assert_equal 1.5, rules.price_discount_for( :SR1, 1, 3)
    assert_equal 2.0, rules.price_discount_for( :SR1, 1, 4)
  end

  def test_percentage_discount
    rules = PricingRules.instance

    assert_equal 0, rules.price_discount_for( :CF1, 1, 0)
    assert_equal 0, rules.price_discount_for( :CF1, 1, 1)
    assert_equal 1.0, rules.price_discount_for( :CF1, 1, 3)
    assert_equal 1.33, rules.price_discount_for( :CF1, 1, 4)
  end  
end