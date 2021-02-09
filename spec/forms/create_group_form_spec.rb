# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateGroupForm, type: :form do
  subject(:form) { described_class.new(**input, owner: owner) }

  let(:input) { attributes_for(:create_group_input) }
  let(:owner) { create(:pone, :verified) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it 'is invalid without a name' do
    input[:name] = nil
    expect(form).to be_invalid
  end

  it 'is invalid when the name is too long' do
    input[:name] = 'a' * (Group::NAME_MAX_LENGTH + 1)
    expect(form).to be_invalid
  end

  it 'is valid without a description' do
    input[:description] = nil
    expect(form).to be_valid
  end

  it 'is invalid when the description is too long' do
    input[:description] = 'a' * (Group::DESCRIPTION_MAX_LENGTH + 1)
    expect(form).to be_invalid
  end

  it 'is invalid when the owner is not verified' do
    owner.verified_at = nil
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the newly created group' do
      expect(perform).to be_a(Group)
        .and be_persisted
        .and have_attributes(owner: owner)
    end

    it 'saves the input information to the group record' do
      expect(perform).to have_attributes(
        name:        input[:name],
        description: input[:description]
      )
    end
  end
end
