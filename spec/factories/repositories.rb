FactoryGirl.define do
  factory :repository do
    full_name { Faker::Name.name }
  end
end
