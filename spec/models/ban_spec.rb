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
require 'rails_helper'

RSpec.describe Ban, type: :model do
  subject(:ban) { build(:ban) }

  it 'has a valid factory' do
    expect(ban).to be_valid
  end

  it 'is invalid without a pone' do
    ban.pone = nil
    expect(ban).to be_invalid
  end

  it 'is invalid without a issuer' do
    ban.issuer = nil
    expect(ban).to be_invalid
  end

  it 'is invalid without a reason' do
    ban.reason = nil
    expect(ban).to be_invalid
  end

  it 'is invalid when the reason is too long' do
    ban.reason = 'a' * (described_class::REASON_MAX_LENGTH + 1)
    expect(ban).to be_invalid
  end
end
