require 'rubygems'
require 'sinatra'
require 'redcloth'
require 'digest/sha1'
require 'xml-sitemap'
require 'chronic'
require 'chronic_duration'
require 'chronic_distance'
require 'haml'

require './db'
require './helper'
require './graph'

helpers Helpers
enable :sessions

#except_before(['/drafts/*', '/logs']) do
#  l = Log.new
#  l.path = request.fullpath
#  l.user_agent = request.user_agent
#  l.ip = request.remote_ip
#  l.referer = request.referer
#  l.date = Time.new
#  l.save
#end

get '/' do
  if logged_in?
    @articles = Article.order(:publish_date.desc).limit(5)
  else
    @articles = Article.filter(:published => true).order(:publish_date.desc).limit(5)
  end
  @totals = Exercise.totals
  haml :home
end

get '/about' do
  @title = "about me"
  haml :about
end

get '/archive' do
  @years = Exercise.years
  @title = "archive"
  haml :archive
end

get '/archive/:year' do
  @totals = Exercise.month_totals(params[:year])
  @title = params[:year]
  haml :archive_year
end

get '/archive/:year/:month' do
  the_date = Time.mktime(params[:year], params[:month])
  @sports = Exercise.filter(:start_time => the_date.start_of_month...the_date.end_of_month)
  @title = "#{Date::MONTHNAMES[params[:month].to_i]} #{params[:year]}"
  haml :sport_log
end

get '/week' do
  @sports = Exercise.filter(:start_time => Time.now.start_of_week...Time.now.end_of_week)
  @title = "week"
  haml :sport_log
end

get '/month' do
  @sports = Exercise.filter(:start_time => Time.now.start_of_month...Time.now.end_of_month)
  @title = "month"
  haml :sport_log
end

get '/year' do
  @sports = Exercise.filter(:start_time => Time.now.start_of_year...Time.now.end_of_year)
  @title = "year"
  haml :sport_log
end
get '/detail/:id' do
  @exercise = Exercise.first(:id => params[:id])
  @title = "Details for " + short_date(@exercise.start_time)
  haml :detail
end

get '/sport/new' do
  login_required
  @exercise = Exercise.new
  @exercise.duration = 0
  haml :sport_new
end
get '/sport/:id' do
  login_required
  @exercise = Exercise.first(:id => params[:id])
  haml :sport_new
end
post '/sport' do
  login_required
  @exercise = 
    if params[:id].empty?
      Exercise.create
    else
      Exercise[params[:id].to_i]
    end
    @exercise.remove_all_tags unless params[:id].empty?
    @exercise.start_time = Chronic.parse(params[:start_time])
    @exercise.duration = ChronicDuration.parse(params[:duration])
    @exercise.distance = ChronicDistance.parse(params[:distance])
    @exercise.comment = params[:comment]
    @exercise.tag_names = params[:tags]
    @exercise.tags.each do |t|
      t.name.downcase!
      @exercise.add_tag(t)
    end
    @exercise.save
    redirect '/'
end
get '/delete/:id' do
  login_required
  if params[:id].empty?
    #flash[:error] = "you're being naughty"
    redirect '/'
  end
  Exercise.delete(params[:id])
  #flash[:success] = "exercise deleted"
  redirect '/'
end

get '/blog' do
  if logged_in?
    @articles = Article.order(:publish_date.desc)
  else
    @articles = Article.filter(:published => true).order(:publish_date.desc)
  end
  @title = "archive"
  haml :blog
end

get '/blog/:slug' do
  @article = Article.first(:slug => params[:slug])
  @title = @article.title
  haml :view
end

get '/drafts/new' do
  login_required
  @article = Article.new
  @article.publish_date = Time.new
  @title = "new post"
  haml :edit
end

get '/drafts/:slug' do
  login_required
  @article = Article.first(:slug => params[:slug])
  @title = @article.title
  haml :edit
end

post '/drafts' do
  login_required
  @article = 
    if params[:id].empty?
      Article.create
    else
      Article[params[:id].to_i]
    end
  @article.remove_all_tags unless params[:id].empty?
  @article.title = params[:title]
  @article.body = params[:body]
  @article.tag_names = params[:tags]
  @article.publish_date = Time.new unless !@article.publish_date.nil?
  if params[:submit] == "publish"
    @article.publish_date = Time.new
    @article.published = true
  end
  @article.tags.each do |t|
    @article.add_tag(t)
  end
  @article.slug = slug(params[:title], @article.publish_date)
  @article.save
  redirect '/blog/'+@article.slug
end

get '/tags' do
  @tags = Tag.all
  @title = "all tags"
  haml :tags
end

get '/tags/:tag' do
  @articles = Article.tagged(params[:tag])
  @sports = Exercise.tagged(params[:tag])
  @title = "articles tagged with " + params[:tag]
  haml :view_tag
end

get '/login' do
  @title = "log in"
  haml :login
end
post '/login' do
  if u = User.authenticate(params[:username], params[:password])
    session[:user] = u.id
    #flash[:success] = "logged in"
    redirect_to_stored
  else
    redirect '/login'
  end
end
get '/logout' do
  session[:user] = nil
  #flash[:success] = "logged out"
  redirect '/'
end

get '/convert' do
  haml :convert
end

not_found do
  status 404
  @title = '404'
  haml :'404', :layout => :plain
end

get '/sitemap.xml' do
  articles = Article.filter(:published => true).order(:publish_date.desc)
  tags = Tag.all
  map = XmlSitemap::Map.new('watchmetrain.net') do |m|
    m.add(:url => '/', :period => :daily)
    m.add(:url => '/week', :period => :daily)
    m.add(:url => '/month', :period => :daily)
    m.add(:url => '/year', :period => :daily)
    m.add(:url => '/blog', :period => :daily)
    m.add(:url => '/about')
    m.add(:url => '/convert')
    articles.each do |a|
      m.add(
        :url => '/blog/'+a.slug,
        :updated => a.publish_date,
        :period => :never
      )
    end
    m.add(:url => '/tags', :period => :daily)
    tags.each do |t|
      m.add(
        :url => '/tags/'+t.name
      )
    end
  end
  
  headers['Content-Type'] = 'text/xml'
  map.render
end

get '/feed.xml' do
  @articles = Article.filter(:published => true).order(:publish_date.desc).limit(10)
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "watchmetrain"
        xml.description "a log and graphs"
        xml.link "https://watchmetrain.net/"

        @articles.each do |a|
          xml.item do
            xml.title a.title
            xml.link "https://watchmetrain.net/blog/#{a.slug}"
            xml.description a.html_body
            xml.pubDate Time.parse(a.date.to_s).rfc822()
            xml.guid "https://watchmetrain.net/blog/#{a.slug}"
          end
        end
      end
    end
  end
end

get '/logs' do
  login_required
  @title = "the logs"
  @logs = Log.all
  haml :logs
end

graph "Monthly", {:prefix => '/graphs/:year'} do
  line "km", Exercise.month_totals(params[:year])
end

graph "Yearly", {:prefix => '/graphs'} do
  line "km", Exercise.year_totals
end

