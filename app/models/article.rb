class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, length: { maximum: 10000 }, allow_blank: true

  # 公開時は本文必須（タイトルは常時必須のためここでは本文のみを条件付きで検証）
  validates :body, presence: true, if: :published?

  # 公開済みの記事を抽出するスコープ
  scope :published, -> { where(published: true) }
end
