# frozen_string_literal: true

FactoryBot.define do
  factory :sign_in_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    name { pone.name }
    password { Faker::Internet.password }

    transient do
      pone { create(:pone, :with_password, password: password) }
    end

    trait :incorrect_name do
      name { Faker::Internet.username }
    end

    trait :incorrect_password do
      pone { create(:pone, :with_password) }
    end
  end
end
