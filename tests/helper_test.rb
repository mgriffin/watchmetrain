require 'rubygems'
require 'helper.rb'
require 'chronic_distance'
require 'test/unit'

class HelperTest < Test::Unit::TestCase
  def test_ordinalize
    assert_equal '1st', 1.ordinalize
    assert_equal '2nd', 2.ordinalize
    assert_equal '3rd', 3.ordinalize
    assert_equal '4th', 4.ordinalize
    assert_equal '10th', 10.ordinalize
  end

  def test_to_km
    assert_equal '0km', 0.to_km
    assert_equal '1km', 1000000.to_km
    assert_equal '10km', 10000000.to_km
    assert_equal '54km', 54000000.to_km
    assert_equal '32.5km', 32500000.to_km
  end
end
