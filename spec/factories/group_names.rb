# frozen_string_literal: true

FactoryBot.define do
  sequence(:group_name) do |n|
    "#{Faker::Book.title.truncate(45)} #{n}"
  end
end
