FactoryBot.define do
  factory :story do
    name { Faker::Company.name }
  end
end
