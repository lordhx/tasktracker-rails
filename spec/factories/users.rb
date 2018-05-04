FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password 'password'

    factory :regular_user do
      role :regular
    end

    factory :manager do
      role :manager
    end
  end
end
