# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PonePolicy, type: :policy do
  subject(:policy) { described_class }

  let(:pone) { build(:pone) }
  let(:other_pone) { build(:pone) }

  permissions :index?, :show? do
    it 'permits everyone' do
      expect(policy).to permit(nil, pone)
        .and permit(pone, pone)
        .and permit(pone, other_pone)
    end
  end

  permissions :give_points? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, pone)
    end

    it 'does not permit gives points to yourself' do
      expect(policy).not_to permit(pone, pone)
    end

    it 'permits giving other pones points' do
      expect(policy).to permit(pone, other_pone)
    end
  end

  permissions :integrations?, :change_password?, :update? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, pone)
    end

    it 'permits themselves' do
      expect(policy).to permit(pone, pone)
    end

    it 'does not permit for other pones' do
      expect(policy).not_to permit(pone, other_pone)
    end
  end
end
