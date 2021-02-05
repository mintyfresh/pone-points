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

    (1..@current_pone.giftable_points_count).to_a
  end
end
