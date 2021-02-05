# frozen_string_literal: true

class AGoodPoneAchievementSubscriber
  # @param point [Point]
  def initialize(point)
    @point = point
  end

  # @return [void]
  def perform
    @point.granted_by.unlock_achievement(achievement)
  end

private

  # @return [Achievement]
  def achievement
    Achievement.find_by!(name: 'A Good Pone')
  end
end
