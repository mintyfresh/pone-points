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
class UnlockedAchievement < ApplicationRecord
  belongs_to :pone, inverse_of: :unlocked_achievements
  belongs_to :achievement, inverse_of: :unlocked_achievements
end
