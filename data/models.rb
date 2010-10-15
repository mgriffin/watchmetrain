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

  def update_title(value)

    raise "[ ! ] Could not find title for post" if value.nil?

    self.title = value
    self.name = value.downcase.gsub(/[^\w]/,"_").gsub(/__/,"")
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
  many_to_many :articles, :order => :publish_date.desc
  many_to_many :exercises, :order => :start_time.desc
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
  set_dataset dataset.order(:date.desc)
end

class Exercise < Sequel::Model
  set_dataset dataset.order(:start_time.desc)
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
end