# frozen_string_literal: true

# == Schema Information
#
# Table name: pone_credentials
#
#  id         :bigint           not null, primary key
#  type       :string           not null
#  pone_id    :bigint           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pone_credentials_on_pone_id  (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
require 'rails_helper'

RSpec.describe PoneCredential, type: :model do
  subject(:pone_credential) { build(:pone_credential) }

  it 'has a valid factory' do
    expect(pone_credential).to be_valid
  end
end
