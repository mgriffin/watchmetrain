require 'yaml'
require 'date'
require 'chronic'
require 'chronic_duration'

module Jekyll
  class Sport < Generator
    include Convertible
	
	MATCHER = /^(.+\/)*(\d{4}\d{2}\d{2}-\d{2}\d{2})(\.[^.]+)$/

    # Sport name validator. Sport filenames must be like:
    #   20100830-1715.textile
    #
    # Returns <Bool>
    def self.valid?(name)
      name =~ MATCHER
    end
	
	attr_accessor :data, :content
	attr_accessor :week, :month, :year
	attr_accessor :weekly, :monthly, :yearly
	
	def initialize(site)
	  self.week = 0.0
	  self.month = 0.0
	  self.year = 0.0
	  
	  self.weekly = {}
	  self.monthly = {}
	  self.yearly = {}
	end
	
    def generate(site)
	  base = File.join(site.config['source'], '_sport')
	  
	  Dir.chdir(File.join(site.config['source'], '_sport'))
      Dir.new(Dir.pwd).entries.each do |name|
	    if File.file?(name)
		  self.read_yaml(base, name)
		  date = File.basename(name, ".textile")
		  narf = DateTime::strptime(date, "%Y%m%d-%H%M")
		  date = narf.strftime("%d-%m-%Y")
		  
		  self.weekly[narf.strftime("%Y%m%d")] = {'when' => narf.strftime("%A"), 'what' => [self.data['tag'], self.data['type']].join(', '), 'far' => self.data['distance']/1000, 'long' => self.data['time']} if this_week?(date)
		  self.monthly[narf.strftime("%Y%m%d")] = {'when' => narf.strftime("%A, %d"), 'what' => [self.data['tag'], self.data['type']].join(', '), 'far' => self.data['distance']/1000, 'long' => self.data['time']} if this_month?(date)
		  self.yearly[narf.strftime("%Y%m%d")] = {'when' => narf.strftime("%A, %d %B"), 'what' => [self.data['tag'], self.data['type']].join(', '), 'far' => self.data['distance']/1000, 'long' => self.data['time']} if this_year?(date)
		  
		  if self.data.has_key?('distance')
			self.week += self.data['distance'] if this_week?(date)
			self.month += self.data['distance'] if this_month?(date)
			self.year += self.data['distance'] if this_year?(date)
		  end
		end
	  end
	  
	  self.week = self.week/1000
	  self.month = self.month/1000
	  self.year = self.year/1000
	  
	  generate_progress(site)
	  generate_more(site, self.weekly, 'week')
	  generate_more(site, self.monthly, 'month')
	  generate_more(site, self.yearly, 'year')
	end
	
	def generate_progress(site)
	  output = <<EOF
<div class="total">
<a href="/week">
<span class="title">this week</span>
#{self.week}km</a>
</div>
<div class="total">
<a href="/month">
<span class="title">this month</span>
#{self.month}km</a>
</div>
<div class="total">
<a href="/year">
<span class="title">this year</span>
#{self.year}km</a>
</div>
<div class="clear"></div>
EOF
	  File.open(File.join(site.config['source'], '_includes', 'progress.html'), 'w') do |f|
	    f.write(output)
	  end
    end

	def generate_more(site, data, file)
	  File.open(File.join(site.config['source'], file, 'index.html'), 'w') do |w|
		w.write(<<EOF)
---
layout: default
title: #{file}
---
<table>
<thead>
<tr><th>when</th><th>what</th><th>how far</th><th>how long</th></tr>
</thead>
<tbody>
EOF
		data.each do |blah,e|
		  wen = e['when']
		  what = e['what']
		  far = e['far']
		  long = ChronicDuration::output(e['long'], :format => :short)
		  w.write("<tr><td>#{wen}</td><td>#{what}</td><td>#{far}km</td><td>#{long}</td></tr>")
		end
		w.write("</tbody></table>")
	  end
	end
	
	def this_week?(date)
	  Date.today.cweek == Date.strptime(date, "%d-%m-%Y").cweek ? true : false
	end
	def this_month?(date)
	  Date.today.month == Date.strptime(date, "%d-%m-%Y").month ? true : false
	end
	def this_year?(date)
	  Date.today.year == Date.strptime(date, "%d-%m-%Y").year ? true : false
	end

  end
end
