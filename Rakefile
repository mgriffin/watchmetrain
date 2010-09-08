# adapted from  http://github.com/appden/appden.github.com/blob/master/Rakefile

require 'rake/clean'
require 'chronic'
require File.join(Dir.pwd + '/_plugins/date.rb')

desc 'Build site with Jekyll'
task :build => [:clean] do
  # compile site
  jekyll  
end
 
desc 'Start server with --auto'
task :server => [:clean]  do
  jekyll('--server')
end

desc 'Begin a new post'
task :post do   
  ROOT_DIR = File.dirname(__FILE__)

  title = ARGV[1]
  tags = ARGV[2]

  unless title
    puts %{Usage: rake post "The Post Title"["Tag 1, Tag 2"]}
    exit(-1)
  end

  now = Time.now
  date = now.strftime('%Y-%m-%d')
  slug = title.strip.downcase.gsub(/[^a-z0-9 ]/, '')
  slug = slug.gsub(/ /, '-')

  long_date = now.strftime("#{now.day.ordinalize} of %B, %Y")
  # E.g. 20060716-1141-phoenix-park-duathlon.textile
  path = "#{ROOT_DIR}/_posts/#{date}-#{slug}.textile"

  header = <<-END
---
title: #{title}
tags:  [#{tags}]
layout: post
---
h2. {{ page.title }}

#{long_date}

END

  File.open(path, 'w') {|f| f << header }
end  

desc 'Add a new exercise'
task :sport do   
  ROOT_DIR = File.dirname(__FILE__)

  time = ARGV[1]
  date = ARGV[2]

  unless time
    puts %{Usage: rake sport "time" ["day"]}
    exit(-1)
  end

  date ||= "today"
  date = Chronic.parse(date).strftime("%Y%m%d")
  time = Chronic.parse(time).strftime("%H%M")
  # E.g. 20060716-1141.textile
  path = "#{ROOT_DIR}/_sport/#{date}-#{time}.textile"

  header = <<-END
---
tag: 
type: 
time: 
distance: 
---
END

  File.open(path, 'w') {|f| f << header }
end

task :default => :build

# clean deletes built copies
CLEAN.include(['_site/'])

def jekyll(opts = '')
  sh 'jekyll ' + opts
end

