FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    factory :regular_user do
      role :regular
    end

    factory :manager do
      role :manager
    end
  end
end
