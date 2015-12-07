FactoryGirl.define do
  factory :commit do
    sha { Faker::Number.hexadecimal(8) }
    message { Faker::Lorem.sentence }
    committer { Faker::Name.name }
    committed_at 1.day.ago
    association :repository
  end
end
