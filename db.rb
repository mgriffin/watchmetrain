require 'rubygems'
require 'sequel'

DB = Sequel.sqlite

if !DB.table_exists?(:articles) 
  DB.create_table! :articles do
    primary_key :id
    foreign_key :user_id
    String :title
    String :slug
    Text :body
    Boolean :published
    Time :publish_date
    Time :created_at
    Time :updated_at
  end
 end
 if !DB.table_exists?(:tags) 
  DB.create_table! :tags do 
    primary_key :id
    String :name
    Time :created_at
    Time :updated_at
  end
end
if !DB.table_exists?(:articles_tags)
  DB.create_table! :articles_tags do
    foreign_key :article_id, :articles
    foreign_key :tag_id, :tags
  end
end
if !DB.table_exists?(:users)
  DB.create_table! :users do
    primary_key :id
    String :username
    String :hashed_password
    String :salt
    String :name
  end
end
if !DB.table_exists?(:logs)
  DB.create_table! :logs do
    primary_key :id
    String :path
    String :user_agent
    String :ip
    String :referer
    Time :date
  end
end
if !DB.table_exists?(:exercises)
  DB.create_table! :exercises do
    primary_key :id
    Time :when
    Time :taken
    Integer :distance
  end
end
if !DB.table_exists?(:exercises_tags)
  DB.create_table! :exercises_tags do
    foreign_key :exercise_id, :exercises
    foreign_key :tag_id, :tags
  end
end

def body
  a = ""
  25.times { a << "Lorem ipsum dolor sit amet" }
  a << "\n\n"
  25.times { a << "Lorem ipsum dolor sit amet" }
  a
end

def another_body
  a=<<EOF
  blah

  blah

  lorem ipsum dolor sit amet
  things
EOF
end

DB[:articles].insert(:title => "An interesting post", :user_id => 1, :slug =>"20101001-an-interesting-post", :body => another_body, :published => true, :publish_date => '2010-10-01 12:00')
DB[:articles].insert(:title => "Cheese", :user_id => 1, :slug =>"20100906-cheese", :body => body, :published => true, :publish_date => '2010-09-06 12:00')
DB[:articles].insert(:title => "Why do we do it?", :user_id => 1, :slug =>"20100905-why-do-we-do-it", :body => body, :published => false, :publish_date => '2010-09-05 12:00')
DB[:articles].insert(:title => "Yet again", :user_id => 1, :slug =>"20100904-yet-again", :body => body, :published => true, :publish_date => '2010-09-04 12:00')
DB[:articles].insert(:title => "More", :user_id => 1, :slug =>"20100903-more", :body => body, :published => false, :publish_date => '2010-09-03 12:00')
DB[:articles].insert(:title => "More", :user_id => 1, :slug =>"20100902-more", :body => body, :published => true, :publish_date => '2010-09-02 12:00')
DB[:articles].insert(:title => "Published", :user_id => 1, :slug =>"20100901-published", :body => body, :published => true, :publish_date => '2010-09-01 12:00')

DB[:tags].insert(:name => "one")
DB[:tags].insert(:name => "cheese")
DB[:tags].insert(:name => "grammar")
DB[:tags].insert(:name => "cycle")
DB[:tags].insert(:name => "run")

DB[:articles_tags].insert(:tag_id => 1, :article_id => 1)
DB[:articles_tags].insert(:tag_id => 2, :article_id => 1)
DB[:articles_tags].insert(:tag_id => 2, :article_id => 2)
DB[:articles_tags].insert(:tag_id => 3, :article_id => 4)

DB[:users].insert(:username => "mike", :hashed_password => "3cf448e735f411d7e46bafe79388adaced8f7109", :salt => "A L0ng sAl7", :name => "Mike")

DB[:exercises].insert(:when => '2010-10-08 08:04:00', :taken => '00:43:24', :distance => '20360')
DB[:exercises].insert(:when => '2010-10-06 18:45:00', :taken => '01:03:00', :distance => '10600')
DB[:exercises].insert(:when => '2010-09-06 18:45:00', :taken => '01:03:00', :distance => '10600')

DB[:exercises_tags].insert(:tag_id => 4, :exercise_id => 1)
DB[:exercises_tags].insert(:tag_id => 5, :exercise_id => 2)

require 'data/models'