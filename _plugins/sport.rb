require 'yaml'
require 'date'
require 'chronic'
require 'chronic_duration'

module Jekyll
  class Sport < Generator
    include Convertible
	
	safe true
    priority :high
	
	MATCHER = /^(.+\/)*(\d{4}\d{2}\d{2}-\d{2}\d{2})(\.[^.]+)$/

    # Sport name validator. Sport filenames must be like:
    #   20100830-1715.textile
    #
    # Returns <Bool>
    def valid?(name)
      name =~ MATCHER
    end
	
	attr_accessor :data, :content, :date
	attr_accessor :week, :month, :year
	attr_accessor :weekly, :monthly, :yearly
	
	def initialize(site)
	  self.week = 0.0
	  self.month = 0.0
	  self.year = 0.0
	  
	  self.weekly = []
	  self.monthly = []
	  self.yearly = []
	end
	
    def generate(site)
	  base = File.join(site.config['source'], '_sport')
	  return unless File.exists?(base)
	  entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }
	  
	  entries.each do |name|
	    if valid?(name)
		  self.process(name)
		  self.read_yaml(base, name)
		  date = File.basename(name, ".textile")
		  narf = DateTime::strptime(date, "%Y%m%d-%H%M")
		  date = narf.strftime("%d-%m-%Y")
		  
		  self.weekly << {'date' => narf.strftime("%Y%m%d"), 'when' => narf.strftime("%A"), 'what' => [self.data['tag'], self.data['type']].join(', '), 'far' => self.data['distance'], 'long' => self.data['time']} if this_week?(date)
		  self.monthly << {'date' => narf.strftime("%Y%m%d"), 'when' => narf.strftime("%A, #{narf.day.ordinalize}"), 'what' => [self.data['tag'], self.data['type']].join(', '), 'far' => self.data['distance'], 'long' => self.data['time']} if this_month?(date)
		  self.yearly << {'date' => narf.strftime("%Y%m%d"), 'when' => narf.strftime("%A, #{narf.day.ordinalize} %B"), 'what' => [self.data['tag'], self.data['type']].join(', '), 'far' => self.data['distance'], 'long' => self.data['time']} if this_year?(date)
		  
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
	  
	  self.weekly = sort_me(self.weekly)
	  self.monthly = sort_me(self.monthly)
	  self.yearly = sort_me(self.yearly)
	  
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
	  Dir.mkdir(File.join(site.config['source'], '_includes')) unless File.exist?(File.join(site.config['source'], '_includes'))
	  File.open(File.join(site.config['source'], '_includes', 'progress.html'), 'w') do |f|
	    f.write(output)
	  end
    end

	def generate_more(site, data, file)
	  Dir.mkdir(File.join(site.config['source'], file)) unless File.exist?(File.join(site.config['source'], file))
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

		odd = true
		data.each do |e|
		  wen = e['when']
		  what = e['what']
		  far = e['far'].to_f/1000
		  long = ChronicDuration::output(e['long'], :format => :short)
		  if odd
			w.write("<tr class=\"other\">")
			odd = false
		  else
		    w.write("<tr>")
			odd = true
		  end
		  w.write("<td>#{wen}</td><td>#{what}</td><td>#{far}km</td><td>#{long}</td></tr>")
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
	def sort_me(data)
	  data = data.sort_by {|c| "#{:date}" }
	  data.reverse
	end

	# Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # unless they are web server files such as '.htaccess'
    def filter_entries(entries)
      entries = entries.reject do |e|
        unless ['.htaccess'].include?(e)
          ['.', '_', '#'].include?(e[0..0]) || e[-1..-1] == '~'
        end
      end
    end
	
	# Extract information from the sport filename
    #   +name+ is the String filename of the sport file
    #
    # Returns nothing
    def process(name)
      m, date, ext = *name.match(MATCHER)
      self.date = date
    end
  end
end
