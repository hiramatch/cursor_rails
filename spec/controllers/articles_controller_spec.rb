require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  before do
    @article = Article.create!(title: 'テスト記事', body: 'テスト本文', published: false)
  end

  describe 'GET #index' do
    it 'should get index' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'should get new' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'should create article' do
      expect {
        post :create, params: { article: { body: @article.body, published: @article.published, title: @article.title } }
      }.to change(Article, :count).by(1)

      expect(response).to redirect_to(article_path(Article.last))
    end

    it 'create returns 422 and body errors when published without body (JSON)' do
      expect {
        post :create, params: { article: { title: 'T', body: nil, published: true } }, format: :json
      }.not_to change(Article, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json).to have_key('body')
      expect(json['body']).not_to be_empty
    end
  end

  describe 'GET #show' do
    it 'should show article' do
      get :show, params: { id: @article }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'should get edit' do
      get :edit, params: { id: @article }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    it 'should update article' do
      patch :update, params: { id: @article, article: { body: @article.body, published: @article.published, title: @article.title } }
      expect(response).to redirect_to(article_path(@article))
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy article' do
      expect {
        delete :destroy, params: { id: @article }
      }.to change(Article, :count).by(-1)

      expect(response).to redirect_to(articles_path)
    end
  end

  describe 'internationalized success messages' do
    it 'displays success messages for CRUD operations' do
      # 作成成功時のメッセージ
      post :create, params: { article: { title: 'テスト記事', body: 'テスト本文', published: false } }
      expect(response).to redirect_to(article_path(Article.last))
      
      # 更新成功時のメッセージ
      patch :update, params: { id: Article.last, article: { title: '更新された記事', body: '更新された本文', published: true } }
      expect(response).to redirect_to(article_path(Article.last))
      
      # 削除成功時のメッセージ
      delete :destroy, params: { id: Article.last }
      expect(response).to redirect_to(articles_path)
    end
  end
end
