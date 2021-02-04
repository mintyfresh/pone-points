# frozen_string_literal: true

class PonesController < ApplicationController
  def show
    @pone = Pone.find_by!(slug: params[:id])
  end
end
