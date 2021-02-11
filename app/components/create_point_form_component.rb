# frozen_string_literal: true

class CreatePointFormComponent < ApplicationComponent
  # @param pone [Pone]
  # @param form [CreatePointForm]
  # @param current_pone [Pone, nil]
  def initialize(pone:, form:, current_pone:)
    @pone         = pone
    @form         = form
    @current_pone = current_pone
  end

  # @return [Array<Integer>]
  def points_options
    return [] if @current_pone.nil?

    (1..maximum_points_count).to_a
  end

  # @return [Integer]
  def maximum_points_count
    [@current_pone.total_giftable_points_count, 5].min
  end
end
