# frozen_string_literal: true

# == Schema Information
#
# Table name: points
#
#  id            :bigint           not null, primary key
#  pone_id       :bigint           not null
#  granted_by_id :bigint           not null
#  message       :string
#  count         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_points_on_granted_by_id  (granted_by_id)
#  index_points_on_pone_id        (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (granted_by_id => pones.id)
#  fk_rails_...  (pone_id => pones.id)
#
require 'rails_helper'

RSpec.describe Point, type: :model do
  subject(:point) { build(:point) }

  it 'has a valid factory' do
    expect(point).to be_valid
  end
end
