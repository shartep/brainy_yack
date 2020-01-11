FactoryBot.define do
  factory :story do
    name { Faker::Book.name }
  end
end
