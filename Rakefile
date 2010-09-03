# adapted from  http://github.com/appden/appden.github.com/blob/master/Rakefile

require 'rake/clean'
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
  time = Time.now.strftime('')
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

task :default => :build

# clean deletes built copies
CLEAN.include(['_site/','week','month','year','_includes/progress.html'])

def jekyll(opts = '')
  sh 'jekyll ' + opts
end

