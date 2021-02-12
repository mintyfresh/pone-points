# frozen_string_literal: true

module Achievements
  class AGoodPoneAchievementSubscriber < BaseAchievementSubscriber
    subscribe_to 'app.points.create'

    payload_field :point

  protected

    # @return [String]
    def achievement_name
      'A Good Pone'
    end

    # @return [Pone]
    def candidate_for_achievement
      point.granted_by
    end

    # @return [Boolean]
    def conditions_for_achievement_met?
      true # Giving a point is the only condition.
    end
  end
end
