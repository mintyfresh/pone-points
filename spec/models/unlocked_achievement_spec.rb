# frozen_string_literal: true

# == Schema Information
#
# Table name: unlocked_achievements
#
#  id             :bigint           not null, primary key
#  pone_id        :bigint           not null
#  achievement_id :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_unlocked_achievements_on_achievement_id              (achievement_id)
#  index_unlocked_achievements_on_pone_id                     (pone_id)
#  index_unlocked_achievements_on_pone_id_and_achievement_id  (pone_id,achievement_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (achievement_id => achievements.id)
#  fk_rails_...  (pone_id => pones.id)
#
require 'rails_helper'

RSpec.describe UnlockedAchievement, type: :model do
  subject(:unlocked_achievement) { build(:unlocked_achievement) }

  it 'has a valid factory' do
    expect(unlocked_achievement).to be_valid
  end

  it 'is invalid without a pone' do
    unlocked_achievement.pone = nil
    expect(unlocked_achievement).to be_invalid
  end

  it 'is invalid without an achievement' do
    unlocked_achievement.achievement = nil
    expect(unlocked_achievement).to be_invalid
  end
end
