# frozen_string_literal: true

FactoryBot.define do
  factory :create_point_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    count { rand(1..3) }
    message { Faker::Hipster.sentence }

    trait :invalid do
      count { 0 }
    end
  end
end
