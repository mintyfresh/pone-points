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
#
# Indexes
#
#  index_pones_on_name  (name) UNIQUE
#  index_pones_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Pone, type: :model do
  subject(:pone) { build(:pone) }

  it 'has a valid factory' do
    expect(pone).to be_valid
  end

  describe '#verified!' do
    subject(:verified!) { pone.verified! }

    let(:pone) { create(:pone) }

    it 'verifies the pone' do
      expect { verified! }.to change { pone.verified? }.to(true)
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
