require 'test/test_helper.rb'
require 'db.rb'
require 'data/models.rb'

class UserModelTest < Test::Unit::TestCase
  def test_self_authenticate_fails_with_a_fake_user
    assert_equal nil, User.authenticate('narf', '')
  end

  def test_self_authenticate_fails_with_a_wrong_password
    assert_equal nil, User.authenticate('mike', '')
  end

  def test_self_authenticate_passes_with_the_correct_credentials
    user = User.first
    assert_equal user, User.authenticate('mike', 'password')
  end
end
