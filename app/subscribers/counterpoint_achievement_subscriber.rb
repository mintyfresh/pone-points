# frozen_string_literal: true

class CounterpointAchievementSubscriber
  # @param boon [Boon]
  def initialize(boon)
    @boon     = boon
    @giver    = boon.granted_by
    @receiver = boon.pone
  end

  # @return [void]
  def perform
    return if @giver.achievement_unlocked?(achievement)
    return if @receiver.granted_boons.where(created_at: ..@boon.created_at).last&.pone != @giver

    @giver.unlock_achievement(achievement)
  end

private

  # @return [Achievement]
  def achievement
    @achievement ||= Achievement.find_by!(name: 'Counterpoint')
  end
end
