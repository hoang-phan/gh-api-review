FactoryGirl.define do
  factory :file_change do
    filename { Faker::Lorem.words(3).join('/') }
    patch { Faker::Lorem.sentence }
    association :commit
  end
end

