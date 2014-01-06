class Article < Sequel::Model
  many_to_many :tags

  def html_body
    RedCloth.new(body).to_html
  end
  
  def date
    publish_date.strftime "%A, %B %d, %Y"
  end

  def summarise
    html_body.gsub(/^(.*?)<\/p>.*$/mis,'\1')
  end

  def published?
    self.published
  end
  
  def self.tagged(tag)
    if tag = Tag.first(:name => tag)
      tag.articles
    else
      []
    end
  end
  
  def tag_names=(value)
    tags.clear
    tag_names =
      if value.respond_to?(:to_ary)
        value.to_ary
      elsif value.respond_to?(:to_str)
        value.split(/[\s,]+/)
      end
    tag_names.uniq.each do |tag_name|
      tag_name.downcase!
      tag = Tag.find_or_create(:name => tag_name)
      tags << tag
    end
  end

  def tag_names
    tags.collect { |t| t.name }
  end
  
end

class Tag < Sequel::Model
  many_to_many :articles, :order => Sequel.desc(:publish_date)
  many_to_many :exercises, :order => Sequel.desc(:start_time)
end

class User < Sequel::Model
  
  def self.authenticate(username, password)
    current_user = first(:username => username)
    return nil if current_user.nil? || User.encrypt(password, current_user.salt) != current_user.hashed_password
    current_user
  end
  
  protected
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
end

class Log < Sequel::Model
  set_dataset dataset.order(Sequel.desc(:date))
end

class Exercise < Sequel::Model
  #set_dataset dataset.order(Sequel.desc(:start_time))
  set_dataset dataset.exclude({:deleted => true}).order(Sequel.desc(:start_time))
  many_to_many :tags
  
  def self.totals
    week = Exercise.filter(:start_time => Time.now.start_of_week...Time.now.end_of_week).sum(:distance) || 0
    month = Exercise.filter(:start_time => Time.now.start_of_month...Time.now.end_of_month).sum(:distance) || 0
    year = Exercise.filter(:start_time => Time.now.start_of_year...Time.now.end_of_year).sum(:distance) || 0
    {:week => week, :month => month, :year => year }
  end

  def nicetime
    day,month,date,time,offset,year = start_time.to_s.split
    day
  end
  
  def kmdistance
    @distance = ChronicDistance.output(distance, :format => :short, :unit => 'kilometers')
  end
  
  def self.years
    years = []
    years_and_totals = []
    @temp = Exercise.map{ |x| x.start_time }
    @temp.each do |t|
      y = t.year
      years << y
    end
    years.sort!.uniq!
    years.each do |y|
      if y.nil?
      else
        year = Time.mktime(y)
        total = Exercise.filter(:start_time => year.start_of_year...year.end_of_year).sum(:distance).to_i.div(1000000) || 0
        years_and_totals << {:year => y, :total => total}
      end
    end
    years_and_totals
  end
  
  def self.month_totals(year)
    totals = []
    (1..12).each do |month|
      the_date = Time.utc(year.to_i, month)
      narf = Exercise.filter(:start_time => the_date.start_of_month...the_date.end_of_month).sum(:distance) || 0
      totals << narf.to_i.div(1000000)
    end
    totals
  end

  def self.year_totals
    totals = []
    this_year = Time.new.year
    (2008..this_year).each do |year|
      the_date = Time.utc(year)
      narf = Exercise.filter(:start_time => the_date.start_of_year...the_date.end_of_year).sum(:distance) || 0
      totals << narf.to_i.div(1000000)
    end
    totals
  end
  
  def tag_names=(value)
    tags.clear
    tag_names =
      if value.respond_to?(:to_ary)
        value.to_ary
      elsif value.respond_to?(:to_str)
        value.split(/[\s,]+/)
      end
    tag_names.uniq.each do |tag_name|
      tag_name.downcase!
      tag = Tag.find_or_create(:name => tag_name)
      tags << tag
    end
  end

  def tag_names
    tags.collect { |t| t.name }
  end
  
  def self.tagged(tag)
    if tag = Tag.first(:name => tag)
      tag.exercises
    else
      []
    end
  end
  
  def self.delete(id)
    Exercise.filter(:id => id).update(:deleted => true)
  end
end
