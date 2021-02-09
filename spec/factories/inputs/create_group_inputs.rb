# frozen_string_literal: true

FactoryBot.define do
  factory :create_group_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    sequence(:name) { |n| "#{Faker::Book.title} #{n}" }
    description { Faker::Hipster.sentence }

    trait :invalid do
      count { 0 }
    end
  end
end
