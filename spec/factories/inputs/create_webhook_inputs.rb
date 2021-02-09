# frozen_string_literal: true

FactoryBot.define do
  factory :create_webhook_input, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    name { Faker::Book.title }
    url { Faker::Internet.url }
  end
end
