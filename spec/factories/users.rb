# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email {  Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :user do
      role { :user }
    end

    trait :admin do
      role { :admin }
    end
  end
end
