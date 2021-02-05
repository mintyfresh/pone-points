# frozen_string_literal: true

module Pones
  class BoonsController < ApplicationController
    before_action :set_pone

    def new
      authorize(@pone, :give_points?)
      @form = CreateBoonForm.new
    end

    def create
      authorize(@pone, :give_points?)
      @form = CreateBoonForm.new(create_boon_params)

      if @form.perform
        redirect_to pone_path(@pone.slug)
      else
        render 'new'
      end
    end

  private

    def set_pone
      @pone = Pone.find_by!(slug: params[:pone_id])
    end

    def create_boon_params
      params.require(:create_boon_form).permit(:points_count, :reason)
        .merge(pone: @pone, granted_by: current_pone)
    end
  end
end
