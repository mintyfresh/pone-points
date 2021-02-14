# frozen_string_literal: true

# == Schema Information
#
# Table name: points
#
#  id            :bigint           not null, primary key
#  pone_id       :bigint           not null
#  granted_by_id :bigint           not null
#  message       :string           not null
#  count         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  deleted_by_id :bigint
#
# Indexes
#
#  index_points_on_deleted_by_id  (deleted_by_id)
#  index_points_on_granted_by_id  (granted_by_id)
#  index_points_on_pone_id        (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (deleted_by_id => pones.id)
#  fk_rails_...  (granted_by_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
require 'rails_helper'

RSpec.describe Point, type: :model do
  subject(:point) { build(:point) }

  it 'has a valid factory' do
    expect(point).to be_valid
  end

  it 'is invalid without a pone' do
    point.pone = nil
    expect(point).to be_invalid
  end

  it 'is invalid without a granting pone' do
    point.granted_by = nil
    expect(point).to be_invalid
  end

  it 'is invalid without a count' do
    point.count = nil
    expect(point).to be_invalid
  end

  it 'is invalid when the count is zero' do
    point.count = 0
    expect(point).to be_invalid
  end

  it 'is invalid without a message' do
    point.message = nil
    expect(point).to be_invalid
  end

  it 'is invalid when the message is too long' do
    point.message = 'a' * 1001
    expect(point).to be_invalid
  end

  it "increases the pone's total point count by the count when created" do
    expect { point.save! }.to change { point.pone.points_count }.by(point.count)
  end

  it "decreases the pone's total point count by the count when destroyed" do
    point.save!
    expect { point.destroy! }.to change { point.pone.points_count }.by(-point.count)
  end
end
