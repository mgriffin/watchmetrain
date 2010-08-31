require 'date'

module Jekyll
  class Sport < Generator
    safe true
    priority :low

    def generate(site)
	  Dir.chdir(File.join(site.config['source'], '_sport'))
      Dir.new(Dir.pwd).entries.each do |name|
	    if File.file?(name)
		  date = File.basename(name, ".html")
		  narf = DateTime::strptime(date, "%Y%m%d-%H%M")
		  puts "date: " + narf.strftime("%d-%m-%Y")
		  puts "time: " + narf.strftime("%H:%M")
		end
	  end
    end

  end
end
