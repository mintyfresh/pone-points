# frozen_string_literal: true

module Achievements
  # @abstract
  class BaseAchievementSubscriber < ApplicationSubscriber
    process_in_background

    # @return [void]
    def perform
      return if candidate_for_achievement.achievement_unlocked?(achievement)

      candidate_for_achievement.unlock_achievement(achievement) if conditions_for_achievement_met?
    end

    # @abstract
    # @return [Achievement]
    def achievement
      @achievement ||= Achievement.find_by!(name: achievement_name)
    end

  protected

    # @abstract
    # @return [String]
    def achievement_name
      raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
    end

    # @abstract
    # @return [Pone]
    def candidate_for_achievement
      raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
    end

    # @abstract
    # @return [Boolean]
    def conditions_for_achievement_met?
      raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
    end
  end
end
