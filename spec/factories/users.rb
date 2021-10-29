FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test+#{n}@test.test" }
    password 'secret123'
    password_confirmation{ |u| u.password }
  end
end
