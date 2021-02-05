# frozen_string_literal: true

class BoonsController < ApplicationController
  def recent
    @boons = Boon.order(created_at: :desc, id: :desc)
  end
end
