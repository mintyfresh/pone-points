# frozen_string_literal: true

# == Schema Information
#
# Table name: achievements
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string           not null
#  pones_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_achievements_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :achievement do
    sequence(:name) { |n| "#{Faker::Book.title} #{n}" }
    description { Faker::Hipster.sentence }
  end
end
