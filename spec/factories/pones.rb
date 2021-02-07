# frozen_string_literal: true

# == Schema Information
#
# Table name: pones
#
#  id                          :bigint           not null, primary key
#  name                        :citext           not null
#  slug                        :string           not null
#  points_count                :integer          default(0), not null
#  daily_giftable_points_count :integer          default(0), not null
#  verified_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_pones_on_name  (name) UNIQUE
#  index_pones_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :pone do
    sequence(:name) { |n| "#{Faker::Internet.username} #{n}" }

    trait :verified do
      verified_at { 5.minutes.ago }
      daily_giftable_points_count { 3 }
    end

    trait :with_avatar do
      after(:build) do |pone|
        pone.avatar.attach(
          io:           File.open(Rails.root.join('spec', 'support', 'avatar.png')),
          filename:     'avatar.png',
          content_type: 'image/png'
        )
      end
    end

    trait :with_points do
      transient do
        points_count { 3 }
      end

      after(:build) do |pone, e|
        pone.points = build_list(:point, e.points_count, pone: pone)
      end
    end

    trait :with_achievements do
      transient do
        achievements_count { 3 }
      end

      after(:build) do |pone, e|
        pone.achievements = Achievement.all.to_a.sample(e.achievements_count)
      end
    end

    trait :with_password do
      transient do
        password { Faker::Internet.password }
      end

      after(:build) do |pone, e|
        pone.credentials << build(:pone_password_credential, password: e.password)
      end
    end
  end
end
