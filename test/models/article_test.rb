require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "draft can be saved without body" do
    article = Article.new(title: "T", body: nil, published: false)
    assert article.valid?
  end

  test "published requires body" do
    article = Article.new(title: "T", body: nil, published: true)
    assert_not article.valid?
    assert_includes article.errors[:body], "can't be blank"
  end

  test "title max length 100" do
    article = Article.new(title: "a" * 101, body: "b", published: false)
    assert_not article.valid?
    assert_includes article.errors[:title], "is too long (maximum is 100 characters)"
  end

  test "body max length 10000 with allowance for blank" do
    article = Article.new(title: "T", body: "a" * 10001, published: false)
    assert_not article.valid?
    assert_includes article.errors[:body], "is too long (maximum is 10000 characters)"

    article_ok = Article.new(title: "T", body: "", published: false)
    assert article_ok.valid?
  end

  test "published scope returns only published articles" do
    published = Article.create!(title: "TP", body: "B", published: true)
    draft     = Article.create!(title: "TD", body: "B", published: false)

    ids = Article.published.pluck(:id)
    assert_includes ids, published.id
    refute_includes ids, draft.id
  end
end
