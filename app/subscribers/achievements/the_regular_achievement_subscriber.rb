# frozen_string_literal: true

module Achievements
  class TheRegularAchievementSubscriber < BaseAchievementSubscriber
    subscribe_to 'app.points.create'

    payload_field :point

  protected

    # @return [String]
    def achievement_name
      'The Regular'
    end

    # @return [Pone]
    def candidate_for_achievement
      point.granted_by
    end

    # @return [Boolean]
    def conditions_for_achievement_met?
      # We already know that points were given today.
      gave_points_on_day?(point.created_at - 1.day) &&
        gave_points_on_day?(point.created_at - 2.days)
    end

  private

    # @param date [Date]
    # @return [Boolean]
    def gave_points_on_day?(date)
      point.granted_by.granted_points.on_day(date).any?
    end
  end
end
