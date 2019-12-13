FactoryBot.define do
  factory :article do
    title { Faker::Name.name }
    text { Faker::Books::Lovecraft.paragraphs }
    page_view { Faker::Number.within(range: 1..100) }
    top { 0 }
  end
end