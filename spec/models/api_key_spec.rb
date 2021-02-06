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
require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  subject(:api_key) { build(:api_key) }

  it 'has a valid factory' do
    expect(api_key).to be_valid
  end

  it 'is invalid without a pone' do
    api_key.pone = nil
    expect(api_key).to be_invalid
  end

  it 'is invalid without a name' do
    api_key.name = nil
    expect(api_key).to be_invalid
  end

  it 'is valid without a description' do
    api_key.description = nil
    expect(api_key).to be_valid
  end

  describe '.find_by_token' do
    subject(:find_by_token) { described_class.find_by_token(token) }

    let(:token) { api_key.token }
    let(:api_key) { create(:api_key) }

    it 'returns the matching api key' do
      expect(find_by_token).to eq(api_key)
    end

    context 'when the token is revoked' do
      let(:api_key) { create(:api_key, :revoked) }

      it 'returns nil' do
        expect(find_by_token).to be_nil
      end
    end

    context 'when the token does not exist' do
      let(:token) { 'fake-token' }

      it 'returns nil' do
        expect(find_by_token).to be_nil
      end
    end

    context 'when the token is nil' do
      let(:token) { nil }

      it 'returns nil' do
        expect(find_by_token).to be_nil
      end
    end
  end
end
