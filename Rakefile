require 'rake/testtask'

task :default => :test

task :test do
  ENV['LANG'] = 'C'
  ENV.delete 'LC_CTYPE'
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['tests/*_test.rb']
end

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    sh "rcov -Ilib test/*_test.rb"
  end
end
