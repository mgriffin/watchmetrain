module Jekyll
  module Filters

    def short_date(date)
	  date.strftime("%a #{date.day.ordinalize} %b, %Y")
	end
	
	def long_date(date)
	  date.strftime("%A, #{date.day.ordinalize} of %B %Y")
	end
	
  end
end
class Fixnum
  def ordinalize
    if (11..13).include?(self % 100)
      "#{self}th"
    else
      case self % 10
        when 1; "#{self}st"
        when 2; "#{self}nd"
        when 3; "#{self}rd"
        else    "#{self}th"
      end
    end
  end
end