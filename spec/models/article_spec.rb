require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'validations' do
    it 'draft can be saved without body' do
      article = Article.new(title: 'T', body: nil, published: false)
      expect(article).to be_valid
    end

    it 'published requires body' do
      article = Article.new(title: 'T', body: nil, published: true)
      expect(article).not_to be_valid
      expect(article.errors.of_kind?(:body, :blank)).to be true
    end

    it 'title max length 100' do
      article = Article.new(title: 'a' * 101, body: 'b', published: false)
      expect(article).not_to be_valid
      expect(article.errors.of_kind?(:title, :too_long)).to be true
    end

    it 'body max length 10000 with allowance for blank' do
      article = Article.new(title: 'T', body: 'a' * 10001, published: false)
      expect(article).not_to be_valid
      expect(article.errors.of_kind?(:body, :too_long)).to be true

      article_ok = Article.new(title: 'T', body: '', published: false)
      expect(article_ok).to be_valid
    end
  end

  describe 'scopes' do
    it 'published scope returns only published articles' do
      published = Article.create!(title: 'TP', body: 'B', published: true)
      draft = Article.create!(title: 'TD', body: 'B', published: false)

      ids = Article.published.pluck(:id)
      expect(ids).to include(published.id)
      expect(ids).not_to include(draft.id)
    end

    it 'published scope with Japanese context' do
      published_article = Article.create!(title: '公開記事', body: '公開本文', published: true)
      draft_article = Article.create!(title: '下書き記事', body: '下書き本文', published: false)
      
      published_articles = Article.published
      expect(published_articles).to include(published_article)
      expect(published_articles).not_to include(draft_article)
      expect(published_articles.count).to eq(1)
    end
  end

  describe 'internationalized validation error messages' do
    it 'displays Japanese error messages for title' do
      article = Article.new(title: '', body: '本文', published: false)
      expect(article).not_to be_valid
      
      error_messages = article.errors.full_messages
      expect(error_messages.any? { |msg| msg.include?('タイトル') }).to be true
    end

    it 'displays Japanese error messages for body' do
      article = Article.new(title: 'タイトル', body: 'a' * 10001, published: false)
      expect(article).not_to be_valid
      
      error_messages = article.errors.full_messages
      expect(error_messages.any? { |msg| msg.include?('本文') }).to be true
    end
  end
end
