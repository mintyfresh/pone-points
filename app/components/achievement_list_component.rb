# frozen_string_literal: true

class AchievementListComponent < ApplicationComponent
  # @param pone [Pone]
  def initialize(pone:)
    @pone = pone
  end

  # @return [Array<UnlockedAchievement>]
  def unlocked_achievements
    @unlocked_achievements ||= @pone.unlocked_achievements
      .joins(:achievement)
      .order(Achievement.arel_table[:name])
      .preload(:achievement, :pone)
  end

  # @return [Array<Achievement>]
  def locked_achievements
    @locked_achievements ||= Achievement
      .where.not(id: unlocked_achievements.unscope(:order, :joins).select(:achievement_id))
      .order(:name)
  end
end
