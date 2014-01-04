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

  def test_tagged
    tagged_article = Article.tagged('run')
    assert_equal 1, tagged_article[0][:id]
  end

  def test_tagged_with_an_invalid_tag
    tagged_article = Article.tagged('narf')
    assert_equal [], tagged_article
  end
end
