# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignUpForm, type: :form do
  subject(:form) { described_class.new(input) }

  let(:input) { attributes_for(:sign_up_input) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid without a name' do
    input[:name] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the name contains unsupported characters' do
    input[:name] = "\0" * 10
    expect(form).to be_invalid
  end

  it 'is invalid when the name is too short' do
    input[:name] = 'a' * (DisplayNameValidator::MINIMUM_LENGTH - 1)
    expect(form).to be_invalid
  end

  it 'is invalid when the name is too long' do
    input[:name] = 'a' * (DisplayNameValidator::MAXIMUM_LENGTH + 1)
    expect(form).to be_invalid
  end

  it 'is invalid when the name contains whitespace only' do
    input[:name] = ' ' * 10
    expect(form).to be_invalid
  end

  it 'is invalid without a password' do
    input[:password] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the password is too short' do
    input[:password] = 'a' * (PasswordValidator::MINIMUM_LENGTH - 1)
    expect(form).to be_invalid
  end

  it 'is invalid when the password is too long' do
    input[:password] = 'a' * (PasswordValidator::MAXIMUM_LENGTH + 1)
    expect(form).to be_invalid
  end

  it 'is invalid without a password confirmation' do
    input[:password_confirmation] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the password does not match the confirmation' do
    input[:password]              = 'a' * 10
    input[:password_confirmation] = 'b' * 10
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the newly created pone' do
      expect(perform).to be_a(Pone)
        .and be_persisted
        .and have_attributes(name: input[:name])
    end

    it 'creates the pone in an unverified state' do
      expect(perform).not_to be_verified
    end

    it 'allows the pone to authenticate with their chosen password' do
      pone = perform
      expect(pone.authenticate(PonePasswordCredential, input[:password])).to eq(pone)
    end

    context 'when the input is invalid' do
      let(:input) { attributes_for(:sign_up_input, :invalid) }

      it 'returns false' do
        expect(perform).to be(false)
      end

      it "doesn't persist a pone to the database" do
        expect { perform }.not_to change { Pone.count }
      end
    end

    context 'when a pone is already signed up with the same name' do
      let(:input) { build(:sign_up_input, name: existing_pone.name) }
      let!(:existing_pone) { create(:pone) }

      it 'returns false' do
        expect(perform).to be(false)
      end

      it "doesn't persist a pone to the database" do
        expect { perform }.not_to change { Pone.count }
      end

      it 'sets an error to indicate that the name is taken' do
        perform
        expect(form.errors).to be_of_kind(:name, 'has already been taken')
      end
    end
  end
end
