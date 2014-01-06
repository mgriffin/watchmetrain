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
  end
 end
 if !DB.table_exists?(:tags) 
  DB.create_table! :tags do 
    primary_key :id
    String :name
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
    Time :start_time
    Integer :duration
    Integer :distance
    String :comment
    Boolean :deleted
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

h3. blah

lorem ipsum dolor sit amet
things(r)
EOF
end

DB[:users].insert(:username => "mike", :hashed_password => "3cf448e735f411d7e46bafe79388adaced8f7109", :salt => "A L0ng sAl7", :name => "Mike")

require './data/models'
require './data/posts_import'
require './data/sports_import'
