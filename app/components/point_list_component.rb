# frozen_string_literal: true

class PointListComponent < ApplicationComponent
  # @param points [Array<Point>]
  def initialize(points:)
    @points = points
  end
end
