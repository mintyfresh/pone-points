# frozen_string_literal: true

# == Schema Information
#
# Table name: pones
#
#  id                  :bigint           not null, primary key
#  name                :citext           not null
#  slug                :string           not null
#  discord_id          :string           not null
#  points_count        :integer          default(0), not null
#  daily_points_budget :integer          default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_pones_on_discord_id  (discord_id) UNIQUE
#  index_pones_on_name        (name) UNIQUE
#  index_pones_on_slug        (slug) UNIQUE
#
FactoryBot.define do
  factory :pone do
    sequence(:name) { |n| "#{Faker::Internet.username} #{n}" }
    sequence(:discord_id) { |n| "#{Faker::Internet.username}##{n}" }

    trait :with_boons do
      transient do
        boons_count { 3 }
      end

      after(:build) do |pone, e|
        pone.boons = build_list(:boon, e.boons_count, pone: pone)
      end
    end
  end
end
