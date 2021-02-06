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

RSpec.describe PonePasswordCredential, type: :model do
  subject(:credential) { build(:pone_password_credential) }

  it 'has a valid factory' do
    expect(credential).to be_valid
      .and be_a(described_class)
  end

  it 'is invalid with an external ID' do
    credential.external_id = '12345'
    expect(credential).to be_invalid
  end

  describe '#authenticate' do
    subject(:authenticate) { credential.authenticate(input) }

    let(:input) { password }
    let(:credential) { build(:pone_password_credential, password: password) }
    let(:password) { Faker::Internet.password }

    it 'returns the associated pone when the input password is correct' do
      expect(authenticate).to eq(credential.pone)
    end

    context 'when the input password is incorrect' do
      let(:input) { 'incorrect-password' }

      it 'returns nil' do
        expect(authenticate).to be_nil
      end
    end

    context 'when the input password is blank' do
      let(:input) { nil }

      it 'returns nil' do
        expect(authenticate).to be_nil
      end
    end

    context 'when the stored password is blank' do
      let(:password) { nil }

      it 'returns nil' do
        expect(authenticate).to be_nil
      end
    end
  end

  describe '#password=' do
    subject(:assign_password) { credential.password = password }

    let(:password) { Faker::Internet.password }

    it 'updates the stored password digest' do
      expect { assign_password }.to change { credential.password_digest }
    end

    it 'updates the timestamp of when the password was last changed' do
      expect { assign_password }.to change { credential.last_changed_at }
    end

    context 'when the input password is blank' do
      let(:password) { nil }

      it 'clears the stored password digest' do
        expect { assign_password }.to change { credential.password_digest }.to(nil)
      end

      it 'updates the timestamp of when the password was last changed' do
        expect { assign_password }.to change { credential.last_changed_at }
      end
    end
  end
end
