# frozen_string_literal: true

class SomeponeLikesYouAchievementSubscriber
  # @param boon [Boon]
  def initialize(boon)
    @boon     = boon
    @giver    = boon.granted_by
    @receiver = boon.pone
  end

  def perform
    return if @receiver.achievement_unlocked?(achievement)

    # We already know that points were given today.
    return unless gave_points_on_day?(@boon.created_at - 1.day)
    return unless gave_points_on_day?(@boon.created_at - 2.days)

    @receiver.unlock_achievement(achievement)
  end

private

  # @param date [Date]
  # @return [Boolean]
  def gave_points_on_day?(date)
    boons_granted_to_same_pone.on_day(date).any?
  end

  # @return [ActiveRecord::Relation]
  def boons_granted_to_same_pone
    Boon.where(pone: @receiver, granted_by: @giver)
  end

  # @return [Achievement]
  def achievement
    @achievement ||= Achievement.find_by!(name: 'Somepone Likes You!')
  end
end
