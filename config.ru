ENV['GEM_HOME'] = '/home/mikegriffin/.gems'
ENV['GEM_PATH'] = '$GEM_HOME:/usr/lib/ruby/gems/1.8'
require 'rubygems'
Gem.clear_paths
require 'sinatra'

set :environment, :production
enable :show_exceptions
disable :run, :reload

require 'mg'

run Sinatra::Application