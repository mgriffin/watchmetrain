helpers do
  def days_left
    (Date.parse("2011-05-21")-Date.today).to_i
  end

  def short_date(date)
    date.strftime("%a #{date.day.ordinalize} %b, %Y")
  end

  def long_date(date)
    date.strftime("%A, #{date.day.ordinalize} of %B, %Y")
  end
  
  def slug(title)
    slug = title.strip.downcase.gsub(/[^a-z0-9 ]/, '')
    slug.gsub!(/ /, '-')
    Date.today.strftime("%Y%m%d") + '-' + slug
  end
  
  def alternate(str1 = "odd", str2 = "even")
    @alternate_odd_even_state = true if @alternate_odd_even_state.nil?
    @alternate_odd_even_state = !@alternate_odd_even_state
    @alternate_odd_even_state ? str2 : str1
  end

  # Usage: partial :foo
  def partial(page, locals={})
    haml page, :layout => false, :locals => locals
  end

  ### authinabox from http://gist.github.com/40246
  def login_required
    if session[:user]
      return true
    else
      session[:return_to] = request.fullpath
      redirect '/login'
      pass rescue throw :pass
    end
  end

  def logged_in?
    !!session[:user]
  end
  
  def current_user
    User.first(:id => session[:user])
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect return_to
    else
      redirect '/'
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
        else "#{self}th"
      end
    end
  end
  
  def to_km
    if self == 0
      return "0km"
    end
    ChronicDistance.output(self, :format => :short, :unit => 'kilometers')
  end
end

require 'rack'

module Rack
  class Request

    # The IP address of the upstream-most client (e.g., the browser). This
    # is reliable even when the request is made through a reverse proxy or
    # other gateway.
    def remote_ip
      @env['HTTP_X_FORWARDED_FOR'] || @env['HTTP_CLIENT_IP'] || @env['REMOTE_ADDR']
    end

  end
end

module Sinatra
  module ExceptBeforeFilter
    def except_before(routes, &block)
      before do
        routes.map!{|x| x = x.gsub(/\*/, '\w+')}
        routes_regex = routes.map{|x| x = x.gsub(/\//, '\/')}
        instance_eval(&block) unless routes_regex.any? {|route| (request.path =~ /^#{route}$/) != nil}
      end
    end
  end

  register ExceptBeforeFilter
end

class Time
  def start_of_day
    change(:hour => 0)
  end
  def end_of_day
    change(:hour => 23, :min => 59, :sec => 59)
  end
  def start_of_week
    days_to_monday = self.wday!=0 ? self.wday-1 : 6
    result = self - days_to_monday
    result.start_of_day
  end
  def end_of_week
    days_to_sunday = self.wday!=0 ? 7-self.wday : 0
    result = self + days_to_sunday
    result.end_of_day
  end
  def start_of_month
    change(:day => 1)
  end
  def end_of_month
    #self - ((self.mday-1).days + self.seconds_since_midnight)
    last_day = days_in_month( self.month )
    change(:day => last_day, :hour => 23, :min => 59, :sec => 59, :usec => 0)
  end
  def start_of_year
    change(:month => 1,:day => 1,:hour => 0, :min => 0, :sec => 0, :usec => 0)
  end
  def end_of_year
    change(:month => 12,:day => 31,:hour => 23, :min => 59, :sec => 59)
  end

  def days_in_month(month)
    (Date.new(Time.now.year,12,31)<<(12-month)).day
  end

  def change(options)
    ::Time.send(
      :utc,
      options[:year]  || self.year,
      options[:month] || self.month,
      options[:day]   || self.day,
      options[:hour]  || self.hour,
      options[:min]   || (options[:hour] ? 0 : self.min),
      options[:sec]   || ((options[:hour] || options[:min]) ? 0 : self.sec),
      options[:usec]  || ((options[:hour] || options[:min] || options[:sec]) ? 0 : self.usec)
    )
  end

end