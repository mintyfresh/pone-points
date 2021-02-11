# frozen_string_literal: true

module Achievements
  class AGoodPoneAchievementSubscriber < ApplicationSubscriber
    subscribe_to 'app.points.create'

    process_in_background

    payload_field :point

    # @return [void]
    def perform
      point.granted_by.unlock_achievement(achievement)
    end

  private

    # @return [Achievement]
    def achievement
      Achievement.find_by!(name: 'A Good Pone')
    end
  end
end
