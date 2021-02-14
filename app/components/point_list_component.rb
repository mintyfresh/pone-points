# frozen_string_literal: true

class PointListComponent < ApplicationComponent
  # @param points [Array<Point>]
  # @param current_pone [Pone, nil]
  def initialize(points:, current_pone:)
    @points       = points
    @current_pone = current_pone
  end
end
