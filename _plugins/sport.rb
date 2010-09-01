require 'yaml'
require 'date'
require 'chronic'

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
	
	def initialize(site)
	  self.week = 0.0
	  self.month = 0.0
	  self.year = 0.0
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
		  time = narf.strftime("%H:%M")
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
