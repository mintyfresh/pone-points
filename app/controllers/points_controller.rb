# frozen_string_literal: true

class PointsController < ApplicationController
  def recent
    @points = Point.order(created_at: :desc, id: :desc).preload(:pone, :granted_by)
  end
end
