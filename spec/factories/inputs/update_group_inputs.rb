# frozen_string_literal: true

FactoryBot.define do
  factory :update_group_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    group { create(:group) }
    description { Faker::Hipster.sentence }

    trait :invalid do
      description { 'a' * (Group::DESCRIPTION_MAX_LENGTH + 1) }
    end
  end
end
