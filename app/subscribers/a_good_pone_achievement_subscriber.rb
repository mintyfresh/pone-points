# frozen_string_literal: true

class AGoodPoneAchievementSubscriber
  # @param boon [Boon]
  def initialize(boon)
    @boon = boon
  end

  # @return [void]
  def perform
    @boon.granted_by.unlock_achievement(achievement)
  end

private

  # @return [Achievement]
  def achievement
    Achievement.find_by!(name: 'A Good Pone')
  end
end
