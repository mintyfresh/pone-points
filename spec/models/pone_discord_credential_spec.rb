# frozen_string_literal: true

# == Schema Information
#
# Table name: pone_credentials
#
#  id          :bigint           not null, primary key
#  type        :string           not null
#  pone_id     :bigint           not null
#  data        :jsonb            not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#
# Indexes
#
#  index_pone_credentials_on_pone_id               (pone_id)
#  index_pone_credentials_on_type_and_external_id  (type,external_id) UNIQUE
#  index_pone_credentials_on_type_and_pone_id      (type,pone_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
require 'rails_helper'

RSpec.describe PoneDiscordCredential, type: :model do
  subject(:credential) { build(:pone_discord_credential) }

  it 'has a valid factory' do
    expect(credential).to be_valid
      .and be_a(described_class)
  end

  it 'is invalid without an external ID' do
    credential.external_id = nil
    expect(credential).to be_invalid
  end
end
