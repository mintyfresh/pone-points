# frozen_string_literal: true

class AchievementListItemComponent < ApplicationComponent
  # @param achievement [Achievement]
  # @param unlocked_by [Pone, nil]
  # @parma unlocked_at [Time, nil]
  def initialize(achievement:, unlocked_by: nil, unlocked_at: nil)
    @achievement = achievement
    @unlocked_by = unlocked_by
    @unlocked_at = unlocked_at
  end

  # @return [Boolean]
  def unlocked?
    @unlocked_by.present? || @unlocked_at.present?
  end
end
