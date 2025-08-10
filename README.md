# Cursor Rails

このRailsアプリケーションは、記事管理システムです。

## セットアップ

### 必要な環境
- Docker
- Docker Compose

### インストールと起動

```bash
# 依存関係のインストール
docker compose run --rm web bundle install

# データベースのセットアップ
docker compose run --rm web bin/rails db:create db:migrate

# アプリケーションの起動
docker compose up
```

アプリケーションは http://localhost:3000 でアクセスできます。

## テスト

このアプリケーションではRSpecを使用してテストを実行しています。

### テストの実行

```bash
# 全テストの実行
docker compose run --rm web bundle exec rspec

# 特定のテストファイルの実行
docker compose run --rm web bundle exec rspec spec/models/article_spec.rb

# 特定のディレクトリのテスト実行
docker compose run --rm web bundle exec rspec spec/models/

# テストカバレッジの確認
docker compose run --rm web bundle exec rspec --format html --out coverage/index.html
```

### テストの種類

- **モデルテスト**: `spec/models/` - データの検証とスコープのテスト
- **コントローラーテスト**: `spec/controllers/` - HTTPリクエストの処理テスト
- **システムテスト**: `spec/system/` - ブラウザでの動作テスト（現在はRack::Testドライバーで制限あり）

### テストデータ

FactoryBotを使用してテストデータを生成しています：

```ruby
# 基本的な記事の作成
article = create(:article)

# 公開済み記事の作成
published_article = create(:article, :published)

# 長いタイトルの記事の作成
long_title_article = create(:article, :with_long_title)
```

## 機能

- 記事の作成、表示、編集、削除
- 公開/下書き状態の管理
- 日本語対応
- バリデーション（タイトル必須、本文の長さ制限など）

## 技術スタック

- Ruby on Rails 8.0.2
- PostgreSQL
- RSpec（テストフレームワーク）
- FactoryBot（テストデータ生成）
- Capybara（システムテスト）
- SimpleCov（テストカバレッジ）
