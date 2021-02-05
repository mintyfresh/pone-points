# frozen_string_literal: true

class CounterpointAchievementSubscriber
  # @param point [Point]
  def initialize(point)
    @point    = point
    @giver    = point.granted_by
    @receiver = point.pone
  end

  # @return [void]
  def perform
    return if @giver.achievement_unlocked?(achievement)
    return if @receiver.granted_points.where(created_at: ..@point.created_at).last&.pone != @giver

    @giver.unlock_achievement(achievement)
  end

private

  # @return [Achievement]
  def achievement
    @achievement ||= Achievement.find_by!(name: 'Counterpoint')
  end
end
