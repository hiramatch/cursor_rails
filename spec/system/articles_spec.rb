require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  before do
    @article = Article.create!(title: 'テスト記事', body: 'テスト本文', published: false)
  end

  it 'visiting the index' do
    visit articles_path
    expect(page).to have_selector('h1', text: '記事一覧')
    expect(page).to have_selector('a', text: '新しい記事')
  end

  it 'creating an Article' do
    visit articles_path
    click_on '新しい記事'

    fill_in 'タイトル', with: 'テスト記事'
    fill_in '本文', with: 'テスト本文'
    check '公開状態'
    click_on 'Create Article'

    expect(page).to have_text('記事が正常に作成されました')
    expect(page).to have_text('テスト記事')
    expect(page).to have_text('テスト本文')
    expect(page).to have_text('はい')
  end

  it 'updating an Article' do
    visit articles_path
    click_on 'この記事を表示', match: :first
    click_on 'Edit this article'

    fill_in 'タイトル', with: '更新された記事'
    fill_in '本文', with: '更新された本文'
    uncheck '公開状態'
    click_on 'Update Article'

    expect(page).to have_text('記事が正常に更新されました')
    expect(page).to have_text('更新された記事')
    expect(page).to have_text('更新された本文')
    expect(page).to have_text('いいえ')
  end

  it 'destroying an Article' do
    visit articles_path
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    expect(page).to have_text('記事が正常に削除されました')
  end

  it 'displaying article with Japanese labels' do
    visit article_path(@article)
    
    expect(page).to have_text('タイトル:')
    expect(page).to have_text('本文:')
    expect(page).to have_text('公開状態:')
    expect(page).to have_text(@article.title)
    expect(page).to have_text(@article.body)
  end

  it 'form validation errors in Japanese' do
    visit new_article_path
    
    # タイトルを空にして送信
    fill_in '本文', with: 'テスト本文'
    click_on 'Create Article'
    
    expect(page).to have_text('タイトルを入力してください')
  end
end
