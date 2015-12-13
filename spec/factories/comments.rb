FactoryGirl.define do
  factory :comment do
    external_id { Faker::Number.hexadecimal(8) }
    body { Faker::Lorem.sentence }
    user { Faker::Name.name }
    line { rand(1..30) }
    filename { Faker::Lorem.words(3).join('/') }
    commented_at Time.parse('2015/11/11 20:21:12')
    association :commit
  end
end
