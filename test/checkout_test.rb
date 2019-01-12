require '../lib/checkout'
require 'test/unit'

class CheckoutTest < Test::Unit::TestCase

  def test_checkout_instance
    prince_rules = PricingRules.instance
    assert_kind_of Checkout, Checkout.new( prince_rules)
  end

  def test_scan_item
    co = Checkout.new( PricingRules.instance)

    assert_equal 1, co.scan( :CF1 )
    assert_equal 2, co.scan( :CF1 )
  end

  def test_basket1_total_price
    co = Checkout.new( PricingRules.instance)

    assert_equal 1, co.scan( :GR1 )
    assert_equal 2, co.scan( :SR1 )
    assert_equal 3, co.scan( :GR1 )
    assert_equal 4, co.scan( :GR1 )
    assert_equal 5, co.scan( :CF1 ) 

    assert_equal 22.45, co.total 
  end

  def test_basket2_total_price
    co = Checkout.new( PricingRules.instance)

    assert_equal 1, co.scan( :GR1 )
    assert_equal 2, co.scan( :GR1 )

    assert_equal 3.11, co.total 
  end

  def test_basket3_total_price
    co = Checkout.new( PricingRules.instance)

    assert_equal 1, co.scan( :SR1 )
    assert_equal 2, co.scan( :SR1 )
    assert_equal 3, co.scan( :GR1 )
    assert_equal 4, co.scan( :SR1 ) 

    assert_equal 16.61, co.total 
  end

  def test_basket4_total_price
    co = Checkout.new( PricingRules.instance)

    assert_equal 1, co.scan( :GR1 )
    assert_equal 2, co.scan( :CF1 )
    assert_equal 3, co.scan( :SR1 )
    assert_equal 4, co.scan( :CF1 )
    assert_equal 5, co.scan( :CF1 ) 

    assert_equal 30.57, co.total 
  end

end
