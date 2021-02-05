# frozen_string_literal: true

class PoneProfileComponent < ApplicationComponent
  # @param pone [Pone]
  # @param current_pone [Pone, nil]
  def initialize(pone:, current_pone:)
    @pone         = pone
    @current_pone = current_pone
  end

  # @return [Integer]
  def remaining_points_count
    return 0 if @current_pone.nil?

    @remaining_points_count ||= @current_pone.remaining_points_budget
  end
end
