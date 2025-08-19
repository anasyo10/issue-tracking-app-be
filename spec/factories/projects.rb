FactoryBot.define do
  factory :project do
    name { "Test Project" }

    trait :with_issues do
      after(:create) do |project|
        create_list(:issue, 3, project: project)
      end
    end
  end
end