FactoryBot.define do
  factory :issue do
    association :author, factory: :regular_user
    association :assignee, factory: :manager

    status Issue.statuses.keys.sample
    description { Faker::Lorem.sentence }
  end
end
