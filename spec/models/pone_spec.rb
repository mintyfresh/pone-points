# frozen_string_literal: true

# == Schema Information
#
# Table name: pones
#
#  id                          :bigint           not null, primary key
#  name                        :citext           not null
#  slug                        :string           not null
#  points_count                :integer          default(0), not null
#  daily_giftable_points_count :integer          default(0), not null
#  verified_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  bonus_points_count          :integer          default(0), not null
#  giftable_points_count       :integer          default(0), not null
#
# Indexes
#
#  index_pones_on_name  (name) UNIQUE
#  index_pones_on_slug  (slug) UNIQUE
#
require 'rails_helper'
require_relative 'concerns/verifyable'

RSpec.describe Pone, type: :model do
  subject(:pone) { build(:pone) }

  it 'has a valid factory' do
    expect(pone).to be_valid
  end

  it_behaves_like Verifyable do
    subject(:pone) { create(:pone) }
  end

  context 'with an avatar' do
    subject(:pone) { build(:pone, :with_avatar) }

    it 'has a valid factory' do
      expect(pone).to be_valid
    end

    it 'has an avatar' do
      expect(pone.avatar).to be_attached
    end
  end

  describe '#spend_points' do
    subject(:spend_points) { pone.spend_points(count) }

    let(:pone) { create(:pone, giftable_points_count: count) }
    let(:count) { 3 }

    it "removes the points from the pone's giftable points count" do
      expect { spend_points }.to change { pone.giftable_points_count }.to(0)
    end

    it 'returns a truthy value on success' do
      expect(spend_points).to be_truthy
    end

    context 'when the pone does not have enough points' do
      let(:pone) { create(:pone, giftable_points_count: count - 1) }

      it "doesn't remove any points from the pone's giftable points count" do
        expect { spend_points }.not_to change { pone.giftable_points_count }
      end

      it 'returns a falsey value' do
        expect(spend_points).to be_falsey
      end

      context 'when the pone has enough bonus points to cover the difference' do
        let(:pone) { create(:pone, giftable_points_count: count - 1, bonus_points_count: 2) }

        it "removes all of the pone's normal giftable points and the required number of bonus points" do
          expect { spend_points }.to change { pone.giftable_points_count }.to(0)
            .and change { pone.bonus_points_count }.by(-1)
        end

        it 'returns a truthy value' do
          expect(spend_points).to be_truthy
        end
      end

      context 'when the pone has insufficient points and bonus points combined' do
        let(:pone) { create(:pone, giftable_points_count: count - 2, bonus_points_count: 1) }

        it "doesn't remove any points or bonus points from the pone's account" do
          expect { spend_points }.to not_change { pone.giftable_points_count }
            .and not_change { pone.bonus_points_count }
        end

        it 'returns a falsey value' do
          expect(spend_points).to be_falsey
        end
      end
    end
  end

  describe '#verified!' do
    subject(:verified!) { pone.verified! }

    let(:pone) { create(:pone) }

    it 'verifies the pone' do
      expect { verified! }.to change { pone.verified? }.to(true)
    end

    it 'sets the pones giftable points counts' do
      expect { verified! }
        .to change { pone.giftable_points_count }.to(described_class::DEFAULT_DAILY_GIFTABLE_POINTS_COUNT)
        .and change { pone.daily_giftable_points_count }.to(described_class::DEFAULT_DAILY_GIFTABLE_POINTS_COUNT)
    end

    it 'grants the point 1 point from the system pone' do
      verified!
      expect(pone.points.last).to have_attributes(
        granted_by: described_class.find_by!(name: 'System Pone'),
        count:      1
      )
    end
  end
end
