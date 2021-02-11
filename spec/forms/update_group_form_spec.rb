# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateGroupForm, type: :form do
  subject(:form) { described_class.new(input) }

  let(:input) { build(:update_group_input) }
  let(:group) { input[:group] }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid when the description is too long' do
    input[:description] = 'a' * (Group::DESCRIPTION_MAX_LENGTH + 1)
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the updated group' do
      expect(perform).to eq(group)
        .and have_attributes(description: input[:description])
    end

    context 'when the input is invalid' do
      let(:input) { build(:update_group_input, :invalid) }

      it 'returns false' do
        expect(perform).to be(false)
      end
    end
  end
end
