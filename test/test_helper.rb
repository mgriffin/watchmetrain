require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
end

require 'test/unit'
require 'chronic_distance'
require 'haml'
