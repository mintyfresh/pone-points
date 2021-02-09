# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeaveGroupForm, type: :form do
  subject(:form) { described_class.new(pone: pone, group: group) }

  let!(:membership) { create(:membership, group: group, member: pone) }
  let(:pone) { create(:pone) }
  let(:group) { create(:group) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the deleted membership records' do
      expect(perform).to eq(membership)
        .and be_destroyed
    end

    it 'removes the pone as a member from the group' do
      perform
      expect(group).not_to be_member(pone)
    end

    context 'when the pone is not a member of the group' do
      before(:each) do
        group.remove_member(pone)
      end

      it 'returns the existing membership record' do
        expect(perform).to be_nil
      end
    end
  end
end
