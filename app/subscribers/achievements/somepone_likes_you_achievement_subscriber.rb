# frozen_string_literal: true

module Achievements
  class SomeponeLikesYouAchievementSubscriber < BaseAchievementSubscriber
    subscribe_to 'app.points.create'

    payload_field :point

  protected

    # @return [String]
    def achievement_name
      'Somepone Likes You!'
    end

    # @return [Pone]
    def candidate_for_achievement
      point.pone
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
      points_given_by_and_to_same_pones.on_day(date).any?
    end

    # @return [ActiveRecord::Relation]
    def points_given_by_and_to_same_pones
      Point.where(pone: point.pone, granted_by: point.granted_by)
    end
  end
end
