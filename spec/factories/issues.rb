FactoryBot.define do
  factory :issue do
    association :author, factory: :regular_user
    association :assignee, factory: :manager

    status Issue.status_enums.keys.sample
  end
end
