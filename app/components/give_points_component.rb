# frozen_string_literal: true

class GivePointsComponent < ApplicationComponent
  # @param pone [Pone]
  # @param current_pone [Pone, nil]
  def initialize(pone:, current_pone:)
    @pone         = pone
    @current_pone = current_pone
  end

  # @return [Integer]
  def giftable_points_count
    return 0 if @current_pone.nil?

    @giftable_points_count ||= @current_pone.giftable_points_count
  end

  # @return [Time]
  def daily_points_given_at
    # TODO: Load timezone and offset from environment config.
    time  = ActiveSupport::TimeZone['UTC'].now.beginning_of_day + 17.hours
    time += 1.day if time.past?

    time
  end
end
