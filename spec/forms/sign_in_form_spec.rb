# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignInForm, type: :form do
  subject(:form) { described_class.new(input) }

  let(:input) { attributes_for(:sign_in_input) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid without a name' do
    input[:name] = nil
    expect(form).to be_invalid
  end

  it 'is invalid without a password' do
    input[:password] = nil
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    let(:pone) { Pone.find_by(name: input[:name]) }

    it 'returns the authenticated pone' do
      expect(perform).to eq(pone)
    end

    context 'when the name is incorrect' do
      let(:input) { attributes_for(:sign_in_input, :incorrect_name) }

      it 'returns false' do
        expect(perform).to be(false)
      end

      it 'sets an incorrect-credentials error' do
        perform
        expect(form.errors).to be_of_kind(:base, :incorrect_credentials)
      end
    end

    context 'when the password is incorrect' do
      let(:input) { attributes_for(:sign_in_input, :incorrect_password) }

      it 'returns false' do
        expect(perform).to be(false)
      end

      it 'sets an incorrect-credentials error' do
        perform
        expect(form.errors).to be_of_kind(:base, :incorrect_credentials)
      end
    end
  end
end
