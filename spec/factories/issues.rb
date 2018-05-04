FactoryBot.define do
  factory :issue do
    association :author, factory: :regular_user
    association :assignee, factory: :manager

    status Issue.statuses.keys.sample
    description 'Lorem ipsum'
  end
end
