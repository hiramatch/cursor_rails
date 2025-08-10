require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "draft can be saved without body" do
    article = Article.new(title: "T", body: nil, published: false)
    assert article.valid?
  end

  test "published requires body" do
    article = Article.new(title: "T", body: nil, published: true)
    assert_not article.valid?
    assert article.errors.of_kind?(:body, :blank)
  end

  test "title max length 100" do
    article = Article.new(title: "a" * 101, body: "b", published: false)
    assert_not article.valid?
    assert article.errors.of_kind?(:title, :too_long)
  end

  test "body max length 10000 with allowance for blank" do
    article = Article.new(title: "T", body: "a" * 10001, published: false)
    assert_not article.valid?
    assert article.errors.of_kind?(:body, :too_long)

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

  test "internationalized validation error messages" do
    # タイトルが空の場合
    article = Article.new(title: "", body: "本文", published: false)
    assert_not article.valid?
    
    # エラーメッセージが日本語で表示されることを確認
    error_messages = article.errors.full_messages
    assert error_messages.any? { |msg| msg.include?("タイトル") }
    
    # 本文が長すぎる場合
    article = Article.new(title: "タイトル", body: "a" * 10001, published: false)
    assert_not article.valid?
    
    error_messages = article.errors.full_messages
    assert error_messages.any? { |msg| msg.include?("本文") }
  end

  test "published scope with Japanese context" do
    # 公開済み記事の作成
    published_article = Article.create!(title: "公開記事", body: "公開本文", published: true)
    draft_article = Article.create!(title: "下書き記事", body: "下書き本文", published: false)
    
    # スコープが正しく動作することを確認
    published_articles = Article.published
    assert_includes published_articles, published_article
    refute_includes published_articles, draft_article
    assert_equal 1, published_articles.count
  end
end
