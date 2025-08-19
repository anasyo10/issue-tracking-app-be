FactoryBot.define do
  factory :comment do
    text { "Test comment" }
    association :issue
  end
end