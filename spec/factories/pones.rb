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
#  bonus_points_count          :integer          default(0), not null
#  giftable_points_count       :integer          default(0), not null
#  roles                       :string           default([]), not null, is an Array
#
# Indexes
#
#  index_pones_on_name  (name) UNIQUE
#  index_pones_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :pone do
    sequence(:name) { |n| "#{Faker::Internet.username} #{n}" }

    giftable_points_count { daily_giftable_points_count }

    trait :verified do
      verified_at { 5.minutes.ago }
      daily_giftable_points_count { 3 }
    end

    trait :with_avatar do
      transient do
        image_file_path { Rails.root.join('spec', 'support', 'avatar.png') }
      end

      after(:build) do |pone, e|
        pone.avatar.attach(
          io:       File.open(e.image_file_path),
          filename: File.basename(e.image_file_path)
        )
      end
    end

    trait :with_groups do
      transient do
        groups_count { 3 }
      end

      after(:build) do |pone, e|
        pone.groups = build_list(:group, e.groups_count)
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

    trait :with_granted_points do
      transient do
        granted_points_count { 3 }
      end

      after(:build) do |pone, e|
        pone.granted_points = build_list(:point, e.granted_points_count, granted_by: pone)
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
