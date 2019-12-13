FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    avatar { Faker::Avatar.image }
    password_digest { '123123' }
  end
end