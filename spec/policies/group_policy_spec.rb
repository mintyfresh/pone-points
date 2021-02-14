# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:group) { build(:group) }
  let(:owner) { group.owner }
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

    it 'does not permit banned pones' do
      pone.banned = true
      expect(policy).not_to permit(pone, group)
    end
  end

  permissions :edit?, :update? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, group)
    end

    it 'permits the owner' do
      expect(policy).to permit(owner, group)
    end

    it 'does not permit other pones' do
      expect(policy).not_to permit(pone, group)
    end

    it 'does not permit the owner if they are banned' do
      owner.banned = true
      expect(policy).not_to permit(owner, group)
    end
  end
end
