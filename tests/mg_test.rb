require 'mg.rb'
require 'test/unit'
require 'rack/test'

class MGTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_about
    get '/about'
    assert_match(/Kildare/, last_response.body)
  end
end
