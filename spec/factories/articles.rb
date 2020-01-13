FactoryBot.define do
  factory :article do
    story
    name { Faker::Company.name }
    type { Article::TYPES.sample.to_s }
    text { Faker::Lorem.paragraphs.join("\n") }
  end
end
