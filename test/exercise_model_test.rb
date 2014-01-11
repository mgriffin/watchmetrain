require 'test/test_helper.rb'
require 'db.rb'
require 'data/models.rb'

class ExerciseModelTest < Test::Unit::TestCase
  def setup
    @exercise = Exercise.first
  end

  def test_nicetime
    assert_equal '2011-01-12', @exercise.nicetime
  end

  def test_kmdistance
    assert_equal '1.2km', @exercise.kmdistance
  end

  def test_years
    assert_equal [{:year => 2008, :total => 264}, {:year=>2009, :total=>718}, {:year=>2010, :total=>2137}, {:year=>2011, :total=>1}], Exercise.years
  end

  def test_month_totals
    assert_equal [175, 149, 8, 220, 311, 211, 172, 188, 433, 267, 0, 0], Exercise.month_totals(2010)
  end

  def test_year_totals
    assert_equal [264, 718, 2137, 1, 0, 0, 0], Exercise.year_totals
  end

  def test_tag_names_sets_a_new_tag
    assert_equal 'narf, commute, run', @exercise.tag_names = 'narf, commute, run'
    assert_equal ['narf', 'commute', 'run'], @exercise.tag_names
  end

  def test_tag_names_sets_a_new_tag_with_an_array
    assert_equal ['narf', 'commute', 'run'], @exercise.tag_names = ['narf', 'commute', 'run']
  end

  def test_tag_names
    assert_equal ['commute', 'run'], @exercise.tag_names
  end

  def test_tagged
    tagged_exercise = Exercise.tagged('run')
    assert_equal 222, tagged_exercise[0][:id]
  end

  def test_tagged_with_an_invalid_tag
    tagged_exercise = Exercise.tagged('narf')
    assert_equal [], tagged_exercise
  end
end

