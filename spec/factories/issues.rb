FactoryBot.define do
  factory :issue do
    title { "Test Issue" }
    description { "Test Description" }
    assigned_to { "test@example.com" }
    status { "to_do" }
    association :project

    trait :active do
      status { "active" }
    end

    trait :on_hold do
      status { "on_hold" }
    end

    trait :resolved do
      status { "resolved" }
    end

    trait :with_comments do
      after(:create) do |issue|
        create_list(:comment, 2, issue: issue)
      end
    end
  end
end