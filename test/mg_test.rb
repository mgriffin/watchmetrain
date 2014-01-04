require 'test/test_helper.rb'
require 'mg.rb'
require 'rack/test'

class MGTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
    set :session_secret, 'super secret'
  end

  def test_about
    get '/about'
    assert_match(/Kildare/, last_response.body)
  end
end
