require "application_system_test_case"

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:one)
  end

  test "visiting the index" do
    visit articles_url
    assert_selector "h1", text: "記事一覧"
    assert_selector "a", text: "新しい記事"
  end

  test "creating an Article" do
    visit articles_url
    click_on "新しい記事"

    fill_in "タイトル", with: "テスト記事"
    fill_in "本文", with: "テスト本文"
    check "公開状態"
    click_on "Create Article"

    assert_text "記事が正常に作成されました"
    assert_text "テスト記事"
    assert_text "テスト本文"
    assert_text "はい"
  end

  test "updating an Article" do
    visit articles_url
    click_on "この記事を表示", match: :first
    click_on "Edit this article"

    fill_in "タイトル", with: "更新された記事"
    fill_in "本文", with: "更新された本文"
    uncheck "公開状態"
    click_on "Update Article"

    assert_text "記事が正常に更新されました"
    assert_text "更新された記事"
    assert_text "更新された本文"
    assert_text "いいえ"
  end

  test "destroying an Article" do
    visit articles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "記事が正常に削除されました"
  end

  test "displaying article with Japanese labels" do
    visit article_url(@article)
    
    assert_text "タイトル:"
    assert_text "本文:"
    assert_text "公開状態:"
    assert_text @article.title
    assert_text @article.body
  end

  test "form validation errors in Japanese" do
    visit new_article_url
    
    # タイトルを空にして送信
    fill_in "本文", with: "テスト本文"
    click_on "Create Article"
    
    assert_text "タイトルを入力してください"
  end
end
