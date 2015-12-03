FactoryGirl.define do
  factory :branch do
    name { Faker::Internet.slug }

    association :repository
  end
end
