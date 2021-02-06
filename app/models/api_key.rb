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
class ApiKey < ApplicationRecord
  extend HasGeneratedToken

  belongs_to :pone, inverse_of: :api_keys

  has_generated_token :token

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }

  scope :active, -> { where(revoked_at: nil) }

  # @param token [String, nil]
  # @return [ApiKey, nil]
  def self.find_by_token(token)
    active.find_by_hexdigest(:token, token)
  end

  # @return [Boolean]
  def revoked?
    revoked_at.present?
  end

  # @return [Boolean]
  def revoked!
    with_lock do
      return true if revoked?

      update!(revoked_at: Time.current)
    end
  end
end
