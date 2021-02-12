# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadGroupImageForm, type: :form do
  subject(:form) { described_class.new(input) }

  let(:input) { build(:upload_group_image_input) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid without an image' do
    input[:image] = nil
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    let(:group) { input[:group] }

    it 'returns the updated group' do
      expect(perform).to eq(group)
    end

    it 'uploads the image for the group' do
      perform
      expect(group.image).to be_attached
    end

    context 'when the input is invalid' do
      let(:input) { build(:upload_group_image_input, :invalid) }

      it 'returns false' do
        expect(perform).to be(false)
      end
    end
  end
end
