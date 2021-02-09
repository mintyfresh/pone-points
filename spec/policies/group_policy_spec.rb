# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:group) { build(:group) }
  let(:pone) { build(:pone) }

  permissions :index?, :show? do
    it 'permits everyone' do
      expect(policy).to permit(nil, group)
        .and permit(pone, group)
    end
  end

  permissions :create?, :join?, :leave? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, group)
    end

    it 'permits authenticated pones' do
      expect(policy).to permit(pone, group)
    end
  end
end
