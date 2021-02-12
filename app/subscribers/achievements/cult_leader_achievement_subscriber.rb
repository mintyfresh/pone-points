# frozen_string_literal: true

module Achievements
  class CultLeaderAchievementSubscriber < BaseAchievementSubscriber
    subscribe_to 'app.memberships.create'

    payload_field :membership

  protected

    # @return [String]
    def achievement_name
      'Cult Leader'
    end

    # @return [Pone]
    def candidate_for_achievement
      membership.group.owner
    end

    # @return [Boolean]
    def conditions_for_achievement_met?
      membership.group.members_count >= 10
    end
  end
end
