# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangePasswordForm, type: :form do
  subject(:form) { described_class.new(**input, pone: pone) }

  let(:input) { build(:change_password_input) }
  let(:pone) { create(:pone, :with_password, password: input[:old_password]) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid without an old password' do
    input[:old_password] = nil
    expect(form).to be_invalid
  end

  it 'is invalid without an new password' do
    input[:new_password] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the new password is too short' do
    input[:new_password] = 'a' * (PasswordValidator::MINIMUM_LENGTH - 1)
    expect(form).to be_invalid
  end

  it 'is invalid when the new password is too long' do
    input[:new_password] = 'a' * (PasswordValidator::MAXIMUM_LENGTH + 1)
    expect(form).to be_invalid
  end

  it 'is invalid without an new password confirmation' do
    input[:new_password_confirmation] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the new password does not match the confirmation' do
    input[:new_password]              = 'a' * 10
    input[:new_password_confirmation] = 'b' * 10
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the updated pone' do
      expect(perform).to eq(pone)
    end

    it 'allows the pone to authenticate with the new password' do
      perform
      expect(pone.authenticate(PonePasswordCredential, input[:new_password])).to be_truthy
    end

    it 'no longer permits use of the old password' do
      perform
      expect(pone.authenticate(PonePasswordCredential, input[:old_password])).to be_falsey
    end

    context 'when the input is invalid' do
      let(:input) { build(:change_password_input, :invalid) }

      it 'returns false' do
        expect(perform).to be(false)
      end

      it 'does not allow the pone to authenticate with the new password' do
        perform
        expect(pone.authenticate(PonePasswordCredential, input[:new_password])).to be_falsey
      end

      it 'permits the pone to continue to use their old password' do
        perform
        expect(pone.authenticate(PonePasswordCredential, input[:old_password])).to be_truthy
      end
    end
  end
end
