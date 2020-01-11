FactoryBot.define do
  factory :article do
    story
    name { Faker::Book.name }
    type { Article::TYPES.sample.to_s }
    text { Faker::Lorem.paragraphs }
  end
end
