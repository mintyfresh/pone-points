# frozen_string_literal: true

module Achievements
  class TheGroupieAchievementSubscriber < BaseAchievementSubscriber
    subscribe_to 'app.memberships.create'

    payload_field :membership

  protected

    # @return [String]
    def achievement_name
      'The Groupie'
    end

    # @return [Pone]
    def candidate_for_achievement
      membership.member
    end

    # @return [Boolean]
    def conditions_for_achievement_met?
      true # Joining the group is the only condition.
    end
  end
end
