require 'test/test_helper.rb'
require 'mg.rb'
require 'rack/test'

class MGTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
    set :session_secret, 'super secret'
  end

  def test_index
    get '/'
    assert_match(/this week/, last_response.body)
    assert_match(/this month/, last_response.body)
    assert_match(/this year/, last_response.body)
    assert_match(/Championship Semi Final/, last_response.body) # the latest blog post
    assert_match(/Howth Aquathon/, last_response.body)          # the oldest blog post
  end

  def test_about
    get '/about'
    assert_match(/Kildare/, last_response.body)
  end
end
