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

RSpec.describe PonePasswordCredential, type: :model do
  subject(:pone_password_credential) { build(:pone_password_credential) }

  it 'has a valid factory' do
    expect(pone_password_credential).to be_valid
      .and be_a(described_class)
  end

  describe '#authenticate' do
    subject(:authenticate) { pone_password_credential.authenticate(input) }

    let(:input) { password }
    let(:pone_password_credential) { build(:pone_password_credential, password: password) }
    let(:password) { Faker::Internet.password }

    it 'returns the associated pone when the input password is correct' do
      expect(authenticate).to eq(pone_password_credential.pone)
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
    subject(:assign_password) { pone_password_credential.password = password }

    let(:password) { Faker::Internet.password }

    it 'updates the stored password digest' do
      expect { assign_password }.to change { pone_password_credential.password_digest }
    end

    it 'updates the timestamp of when the password was last changed' do
      expect { assign_password }.to change { pone_password_credential.last_changed_at }
    end

    context 'when the input password is blank' do
      let(:password) { nil }

      it 'clears the stored password digest' do
        expect { assign_password }.to change { pone_password_credential.password_digest }.to(nil)
      end

      it 'updates the timestamp of when the password was last changed' do
        expect { assign_password }.to change { pone_password_credential.last_changed_at }
      end
    end
  end
end
