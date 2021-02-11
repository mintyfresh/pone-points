# frozen_string_literal: true

module Achievements
  class CounterpointAchievementSubscriber < ApplicationSubscriber
    subscribe_to 'app.points.create'

    process_in_background

    payload_field :point

    # @return [void]
    def perform
      return if giver.achievement_unlocked?(achievement)
      return if receiver.granted_points.where(created_at: ..point.created_at).last&.pone != giver

      giver.unlock_achievement(achievement)
    end

  private

    # @return [Pone]
    def giver = point.granted_by

    # @return [Pone]
    def receiver = point.pone

    # @return [Achievement]
    def achievement
      @achievement ||= Achievement.find_by!(name: 'Counterpoint')
    end
  end
end
