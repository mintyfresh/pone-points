# frozen_string_literal: true

# == Schema Information
#
# Table name: api_keys
#
#  id              :bigint           not null, primary key
#  pone_id         :bigint           not null
#  token           :string           not null
#  name            :string           not null
#  description     :string
#  requests_count  :integer          default(0), not null
#  last_request_at :datetime
#  revoked_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_api_keys_on_pone_id          (pone_id)
#  index_api_keys_on_token            (token) UNIQUE
#  index_api_keys_on_token_hexdigest  (encode(digest((token)::text, 'sha256'::text), 'hex'::text)) USING hash
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
FactoryBot.define do
  factory :api_key do
    association :pone, strategy: :build

    name { Faker::Book.title }
    description { Faker::Hipster.sentence }

    trait :revoked do
      revoked_at { 5.minutes.ago }
    end
  end
end
