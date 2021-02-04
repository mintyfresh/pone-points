# frozen_string_literal: true

# == Schema Information
#
# Table name: boons
#
#  id           :bigint           not null, primary key
#  pone_id      :bigint           not null
#  granted_by   :string           not null
#  message_link :string
#  points_count :integer          not null
#  occurred_at  :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_boons_on_pone_id  (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
FactoryBot.define do
  factory :boon do
    association :pone, strategy: :build

    granted_by { Faker::Internet.username }
    message_link { Faker::Internet.url }
    points_count { rand(1..3) }
    occurred_at { Time.current }
  end
end
