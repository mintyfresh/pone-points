# frozen_string_literal: true

# == Schema Information
#
# Table name: pones
#
#  id           :bigint           not null, primary key
#  name         :citext           not null
#  discord_id   :string           not null
#  points_count :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pones_on_discord_id  (discord_id) UNIQUE
#  index_pones_on_name        (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Pone, type: :model do
  subject(:pone) { build(:pone) }

  it 'has a valid factory' do
    expect(pone).to be_valid
  end
end
