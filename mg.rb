require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'redcloth'
require 'digest/sha1'
require 'rack-flash'
require 'xml-sitemap'
require 'chronic'
require 'chronic_duration'
require 'chronic_distance'

require 'db'
require 'helper'

enable :sessions
use Rack::Flash

except_before(['/drafts/*', '/logs']) do
  l = Log.new
  l.path = request.fullpath
  l.user_agent = request.user_agent
  l.ip = request.remote_ip
  l.referer = request.referer
  l.date = Time.new
  l.save
end

get '/' do
  if logged_in?
    @articles = Article.order(:publish_date.desc).limit(5)
  else
    @articles = Article.filter(:published => true).order(:publish_date.desc).limit(5)
  end
  @totals = Exercise.totals
  haml :list
end

get '/week' do
  @sports = Exercise.filter(:when => Time.now.start_of_week...Time.now.end_of_week)
  haml :sport_log
end

get '/month' do
  @sports = Exercise.filter(:when => Time.now.start_of_month...Time.now.end_of_month)
  haml :sport_log
end

get '/year' do
  @sports = Exercise.filter(:when => Time.now.start_of_year...Time.now.end_of_year)
  haml :sport_log
end

get '/sport/new' do
  login_required
  @exercise = Exercise.new
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
end

get '/blog/archive' do
  if logged_in?
    @articles = Article.order(:publish_date.desc)
  else
    @articles = Article.filter(:published => true).order(:publish_date.desc)
  end
  haml :archive
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
  @article.slug = slug(params[:title])
  @article.tag_names = params[:tags]
  @article.publish_date = Time.new unless !@article.publish_date.nil?
  if params[:submit] == "publish"
    @article.publish_date = Time.new
    @article.published = true
  end
  @article.tags.each do |t|
    @article.add_tag(t)
  end
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
  @title = "articles tagged with " + params[:tag]
  haml :home
end

get '/login' do
  @title = "login"
  haml :login
end
post '/login' do
  if u = User.authenticate(params[:username], params[:password])
    session[:user] = u.id
    flash[:success] = "logged in"
    redirect_to_stored
  else
    redirect '/login'
  end
end
get '/logout' do
  session[:user] = nil
  flash[:success] = "logged out"
  redirect '/'
end

get '/404' do
  status 404
end

not_found do
  @title = '404'
  haml :'404', :layout => :plain
end

get '/sitemap.xml' do
  articles = Article.filter(:published => true).order(:publish_date.desc)
  tags = Tag.all
  map = XmlSitemap::Map.new('mikegriffin.ie') do |m|
    m.add(:url => '/', :period => :daily)
    m.add(:url => '/blog/archive', :period => :daily)
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

get '/logs' do
  login_required
  @title = "the logs"
  @logs = Log.all
  haml :logs
end