# frozen_string_literal: true

class TheRegularAchievementSubscriber
  # @param point [Point]
  def initialize(point)
    @point = point
    @giver = point.granted_by
  end

  # @return [void]
  def perform
    return if @giver.achievement_unlocked?(achievement)

    # We already know that points were given today.
    return unless gave_points_on_day?(@point.created_at - 1.day)
    return unless gave_points_on_day?(@point.created_at - 2.days)

    @giver.unlock_achievement(achievement)
  end

private

  # @param date [Date]
  # @return [Boolean]
  def gave_points_on_day?(date)
    @giver.granted_points.on_day(date).any?
  end

  # @return [Achievement]
  def achievement
    @achievement ||= Achievement.find_by!(name: 'The Regular')
  end
end
