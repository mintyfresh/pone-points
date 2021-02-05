# frozen_string_literal: true

class UnlockedAchievementListComponent < ApplicationComponent
  # @param unlocked_achievements [Array<UnlockedAchievement>]
  def initialize(unlocked_achievements:)
    @unlocked_achievements = unlocked_achievements
  end
end
