FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "記事タイトル#{n}" }
    body { "記事の本文です。" }
    published { false }

    trait :published do
      published { true }
    end

    trait :with_long_title do
      title { "a" * 101 }
    end

    trait :with_long_body do
      body { "a" * 10001 }
    end

    trait :without_title do
      title { "" }
    end

    trait :without_body do
      body { nil }
    end
  end
end
