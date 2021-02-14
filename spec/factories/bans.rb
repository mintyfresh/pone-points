# frozen_string_literal: true

# == Schema Information
#
# Table name: bans
#
#  id         :bigint           not null, primary key
#  pone_id    :bigint           not null
#  issuer_id  :bigint           not null
#  reason     :string           not null
#  expires_at :datetime
#  revoked_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bans_on_issuer_id  (issuer_id)
#  index_bans_on_pone_id    (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (issuer_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
FactoryBot.define do
  factory :ban do
    association :pone, strategy: :build
    association :issuer, factory: :pone, strategy: :build

    reason { Faker::Hipster.sentence }
    expires_at { 3.days.from_now }

    trait :permanent do
      expires_at { nil }
    end

    trait :revoked do
      revoked_at { 5.minutes.ago }
    end
  end
end
