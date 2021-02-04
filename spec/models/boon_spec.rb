# frozen_string_literal: true

# == Schema Information
#
# Table name: boons
#
#  id            :bigint           not null, primary key
#  pone_id       :bigint           not null
#  granted_by_id :bigint           not null
#  reason        :string
#  points_count  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_boons_on_granted_by_id  (granted_by_id)
#  index_boons_on_pone_id        (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (granted_by_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
require 'rails_helper'

RSpec.describe Boon, type: :model do
  subject(:boon) { build(:boon) }

  it 'has a valid factory' do
    expect(boon).to be_valid
  end
end
