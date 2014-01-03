require 'rake/testtask'

task :default => :test

task :test do
  ENV['LANG'] = 'C'
  ENV.delete 'LC_CTYPE'
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.ruby_opts << '-I.'
end
