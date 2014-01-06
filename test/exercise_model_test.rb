require 'test/test_helper.rb'
require 'db.rb'
require 'data/models.rb'

class ExerciseModelTest < Test::Unit::TestCase
  def setup
    @exercise = Exercise.first
  end

  def test_kmdistance
    assert_equal '1.2km', @exercise.kmdistance
  end
end

