# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadGroupImageForm, type: :form do
  subject(:form) { described_class.new(input) }

  let(:input) { build(:upload_group_image_input) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'does something useful' do
      expect(perform).to be_truthy
    end

    context 'when the input is invalid' do
      let(:input) { build(:upload_group_image_input, :invalid) }

      it 'returns false' do
        expect(perform).to be(false)
      end
    end
  end
end
