# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JoinGroupForm, type: :form do
  subject(:form) { described_class.new(pone: pone, group: group) }

  let(:pone) { create(:pone) }
  let(:group) { create(:group) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the newly created group membership for the pone' do
      expect(perform).to be_a(Membership)
        .and be_persisted
        .and have_attributes(member: pone, group: group)
    end

    it 'adds the pone as a member of the group' do
      perform
      expect(group).to be_member(pone)
    end

    context 'when the pone is already a member of the group' do
      let!(:membership) { group.add_member(pone) }

      it 'returns the existing membership record' do
        expect(perform).to eq(membership)
      end

      it "doesn't create a new membership in the database" do
        expect { perform }.not_to change { group.memberships.count }
      end
    end
  end
end
