# frozen_string_literal: true

module Pones
  class PointsController < ApplicationController
    before_action :set_pone

    def give
      authorize(@pone, :give_points?)
      @form = CreatePointForm.new
    end

    def create
      authorize(@pone, :give_points?)
      @form = CreatePointForm.new(create_point_params)

      if @form.perform
        redirect_to @pone
      else
        render 'give'
      end
    end

  private

    def set_pone
      @pone = Pone.find_by!(slug: params[:pone_id])
    end

    def create_point_params
      params.require(:create_point_form).permit(:count, :message)
        .merge(pone: @pone, granted_by: current_pone)
    end
  end
end
