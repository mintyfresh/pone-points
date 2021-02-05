# frozen_string_literal: true

class BoonsController < ApplicationController
  def recent
    @boons = Boon.order(created_at: :desc, id: :desc).preload(:pone, :granted_by)
  end
end
