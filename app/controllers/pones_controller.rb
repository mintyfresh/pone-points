# frozen_string_literal: true

class PonesController < ApplicationController
  def show
    @pone = Pone.find(params[:id])
  end
end
