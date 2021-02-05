# frozen_string_literal: true

class PonesController < ApplicationController
  def index
    authorize(Pone)
    @pones = policy_scope(Pone).order(:id)
  end

  def show
    @pone = Pone.find_by!(slug: params[:id])
    authorize(@pone)
  end
end
