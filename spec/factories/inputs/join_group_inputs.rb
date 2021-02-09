# frozen_string_literal: true

FactoryBot.define do
  factory :join_group_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    # TODO: Define attributes.

    trait :invalid do
      # TODO: Define invalid input.
    end
  end
end
