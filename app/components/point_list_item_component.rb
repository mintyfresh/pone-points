# frozen_string_literal: true

class PointListItemComponent < ApplicationComponent
  # @param point [Point]
  # @param current_pone [Pone, nil]
  def initialize(point:, current_pone:)
    @point        = point
    @current_pone = current_pone
  end
end
