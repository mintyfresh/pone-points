# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PointPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:point) { build(:point) }
  let(:pone) { build(:pone) }

  permissions :index? do
    it 'permits everyone' do
      expect(policy).to permit(nil, Point)
        .and permit(pone, Point)
    end
  end

  permissions :show? do
    it 'permits everyone' do
      expect(policy).to permit(nil, point)
        .and permit(pone, point)
    end

    it 'does not permit for deleted points' do
      point.deleted = true
      expect(policy).to not_permit(nil, point)
        .and not_permit(pone, point)
    end
  end
end
