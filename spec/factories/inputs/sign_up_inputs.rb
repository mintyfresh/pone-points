# frozen_string_literal: true

FactoryBot.define do
  factory :sign_up_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    sequence(:name) { |n| "#{Faker::Internet.username} #{n}" }
    password { Faker::Internet.password }
    password_confirmation { password }

    trait :invalid do
      name { '' }
    end
  end
end
