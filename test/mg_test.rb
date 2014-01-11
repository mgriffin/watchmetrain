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

  def test_archive
    get'/archive'
    assert_match(/Races I've done/, last_response.body)
  end

  def test_archive_year
    get'/archive/2010'
    assert_match(/January/, last_response.body)
  end

  def test_archive_year_month
    get'/archive/2010/1'
    assert_match(/when/, last_response.body)
    assert_match(/what/, last_response.body)
    assert_match(/how far/, last_response.body)
    assert_match(/how long/, last_response.body)
  end

  def test_week
    get '/week'
    assert_match(/when/, last_response.body)
    assert_match(/what/, last_response.body)
    assert_match(/how far/, last_response.body)
    assert_match(/how long/, last_response.body)
  end

  def test_month
    get '/month'
    assert_match(/when/, last_response.body)
    assert_match(/what/, last_response.body)
    assert_match(/how far/, last_response.body)
    assert_match(/how long/, last_response.body)
  end

  def test_year
    get '/year'
    assert_match(/when/, last_response.body)
    assert_match(/what/, last_response.body)
    assert_match(/how far/, last_response.body)
    assert_match(/how long/, last_response.body)
  end
end
