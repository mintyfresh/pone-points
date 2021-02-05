# frozen_string_literal: true

# == Schema Information
#
# Table name: achievements
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string           not null
#  pones_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_achievements_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Achievement, type: :model do
  subject(:achievement) { build(:achievement) }

  it 'has a valid factory' do
    expect(achievement).to be_valid
  end
end
