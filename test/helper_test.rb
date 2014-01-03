require 'test/test_helper.rb'
require 'helper.rb'

class TestHelper
  include Helpers
end

class HelperTest < Test::Unit::TestCase
  def test_short_date
    helper = TestHelper.new
    assert_equal 'Fri 3rd Jan, 2014', helper.short_date(Time.new(2014,1,3,12,13,14))
  end

  def test_long_date
    helper = TestHelper.new
    assert_equal 'Friday, 3rd of January, 2014', helper.long_date(Time.new(2014,1,3,12,13,14))
  end

  def test_slug
    helper = TestHelper.new
    assert_equal '20140103-this-is-a-title', helper.slug('This is a title', Time.new(2014,1,3,12,13,14))
  end

  def test_ordinalize
    assert_equal '1st', 1.ordinalize
    assert_equal '2nd', 2.ordinalize
    assert_equal '3rd', 3.ordinalize
    assert_equal '4th', 4.ordinalize
    assert_equal '11th', 11.ordinalize
  end

  def test_to_km
    assert_equal '0km', 0.to_km
    assert_equal '1km', 1000000.to_km
    assert_equal '10km', 10000000.to_km
    assert_equal '54km', 54000000.to_km
    assert_equal '32.5km', 32500000.to_km
    assert_equal '20000km', 20000000000.to_km
  end

  def test_start_of_day
    assert_equal Time.new(2014,1,3,0,0,0), Time.new(2014,1,3,12,13,14).start_of_day
  end

  def test_end_of_day
    assert_equal Time.new(2014,1,3,23,59,59), Time.new(2014,1,3,12,13,14).end_of_day
  end

  def test_start_of_week
    assert_equal Time.new(2013,12,30,0,0,0), Time.new(2014,1,3,12,13,14).start_of_week
  end

  def test_end_of_week
    assert_equal Time.new(2014,1,5,23,59,59), Time.new(2014,1,3,12,13,14).end_of_week
  end

  def test_start_of_month
    assert_equal Time.new(2014,1,1,0,0,0), Time.new(2014,1,3,12,13,14).start_of_month
  end

  def test_end_of_month
    assert_equal Time.new(2014,1,31,23,59,59), Time.new(2014,1,3,12,13,14).end_of_month
  end

  def test_start_of_year
    assert_equal Time.new(2014,1,1,0,0,0), Time.new(2014,1,3,12,13,14).start_of_year
  end

  def test_end_of_year
    assert_equal Time.new(2014,12,31,23,59,59), Time.new(2014,1,3,12,13,14).end_of_year
  end
end
