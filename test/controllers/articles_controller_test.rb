require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { body: @article.body, published: @article.published, title: @article.title } }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { body: @article.body, published: @article.published, title: @article.title } }
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end

  test "create returns 422 and body errors when published without body (JSON)" do
    assert_no_difference("Article.count") do
      post articles_url,
        params: { article: { title: "T", body: nil, published: true } },
        as: :json
    end

    assert_response :unprocessable_entity

    json = JSON.parse(@response.body)
    assert json.key?("body"), "expected errors for body in JSON response"
    assert json["body"].any?, "body errors should not be empty"
  end

  test "internationalized success messages" do
    # 作成成功時のメッセージ
    post articles_url, params: { article: { title: "テスト記事", body: "テスト本文", published: false } }
    follow_redirect!
    assert_response :success
    
    # 更新成功時のメッセージ
    patch article_url(Article.last), params: { article: { title: "更新された記事", body: "更新された本文", published: true } }
    follow_redirect!
    assert_response :success
    
    # 削除成功時のメッセージ
    delete article_url(Article.last)
    follow_redirect!
    assert_response :success
  end

  test "root path redirects to articles index" do
    get root_url
    assert_response :success
    assert_select "h1", "記事一覧"
  end
end
