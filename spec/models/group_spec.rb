# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id            :bigint           not null, primary key
#  owner_id      :bigint           not null
#  name          :citext           not null
#  slug          :string           not null
#  description   :string
#  members_count :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_groups_on_name      (name) UNIQUE
#  index_groups_on_owner_id  (owner_id)
#  index_groups_on_slug      (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => pones.id)
#
require 'rails_helper'

RSpec.describe Group, type: :model do
  subject(:group) { build(:group) }

  it 'has a valid factory' do
    expect(group).to be_valid
  end

  it 'is invalid without a name' do
    group.name = nil
    expect(group).to be_invalid
  end

  it 'is invalid when the name is too long' do
    group.name = 'a' * (described_class::NAME_MAX_LENGTH + 1)
    expect(group).to be_invalid
  end

  it 'is valid without a description' do
    group.description = nil
    expect(group).to be_valid
  end

  it 'is invalid when the description is too long' do
    group.description = 'a' * (described_class::DESCRIPTION_MAX_LENGTH + 1)
    expect(group).to be_invalid
  end

  it 'adds the owner as a group member upon creation' do
    expect { group.save! }.to change { group.members.include?(group.owner) }.to(true)
  end
end
