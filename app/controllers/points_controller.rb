# frozen_string_literal: true

class PointsController < ApplicationController
  def recent
    authorize(Point, :index?)

    @points = policy_scope(Point).order(created_at: :desc, id: :desc).preload(:pone, :granted_by)
  end

  def destroy
    @point = Point.find(params[:id])
    authorize(@point).destroy!

    redirect_back(fallback_location: @point.pone)
  end
end
