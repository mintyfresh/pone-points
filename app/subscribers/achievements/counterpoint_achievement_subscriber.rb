# frozen_string_literal: true

module Achievements
  class CounterpointAchievementSubscriber < BaseAchievementSubscriber
    subscribe_to 'app.points.create'

    payload_field :point

  protected

    # @return [String]
    def achievement_name
      'Counterpoint'
    end

    # @return [Pone]
    def candidate_for_achievement
      point.granted_by
    end

    # @return [Boolean]
    def conditions_for_achievement_met?
      point.granted_by == last_pone_given_points_by_recipient
    end

  private

    # @return [Pone, nil]
    def last_pone_given_points_by_recipient
      return @last_pone_given_points_by_recipient if defined?(@last_pone_given_points_by_recipient)

      @last_pone_given_points_by_recipient = point.pone.granted_points
        .where(created_at: ..point.created_at)
        .order(:created_at, :id)
        .last&.pone
    end
  end
end
