# frozen_string_literal: true

# == Schema Information
#
# Table name: pones
#
#  id           :bigint           not null, primary key
#  name         :citext           not null
#  discord_id   :string           not null
#  points_count :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pones_on_discord_id  (discord_id) UNIQUE
#  index_pones_on_name        (name) UNIQUE
#
FactoryBot.define do
  factory :pone do
    sequence(:name) { |n| "#{Faker::Internet.username} #{n}" }
    sequence(:discord_id) { |n| "#{Faker::Internet.username}##{n}" }
  end
end
