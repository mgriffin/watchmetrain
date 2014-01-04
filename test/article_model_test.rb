require 'test/test_helper.rb'
require 'db.rb'
require 'data/models.rb'

class ArticleModelTest < Test::Unit::TestCase
  def setup
    @article = Article.first
  end

  def test_date
    assert_equal 'Monday, October 26, 2009', @article.date
  end

  def test_summarise
    assert_match /<p>I started it/, @article.summarise
  end

  def test_published
    assert @article.published?
  end
end
