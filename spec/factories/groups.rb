# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id            :bigint           not null, primary key
#  owner_id      :bigint           not null
#  name          :citext           not null
#  slug          :string           not null
#  description   :string
#  members_count :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_groups_on_name      (name) UNIQUE
#  index_groups_on_owner_id  (owner_id)
#  index_groups_on_slug      (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => pones.id)
#
FactoryBot.define do
  factory :group do
    association :owner, factory: :pone, strategy: :build

    name { Faker::Book.title }
    description { Faker::Hipster.sentence }

    trait :with_members do
      transient do
        members_count { 3 }
      end

      after(:build) do |group, e|
        group.members = build_list(:pone, e.members_count)
      end
    end
  end
end
