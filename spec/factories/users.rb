FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email {  Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    
    trait :customer do
      role { :customer }
    end

    trait :admin do
      role { :admin }
    end

  end

end