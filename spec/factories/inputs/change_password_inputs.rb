# frozen_string_literal: true

FactoryBot.define do
  factory :change_password_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    old_password { Faker::Internet.password }
    new_password { Faker::Internet.password }
    new_password_confirmation { new_password }

    trait :invalid do
      new_password { '' }
    end
  end
end
