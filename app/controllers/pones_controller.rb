# frozen_string_literal: true

class PonesController < ApplicationController
  SUPPORTED_MODES = %w[points activity achievements groups].freeze

  before_action :set_mode, only: :show

  def index
    authorize(Pone)
    @pones = policy_scope(Pone).order(created_at: :desc, id: :desc).preload(avatar_attachment: :blob)
  end

  def show
    @pone = Pone.find_by!(slug: params[:id])
    authorize(@pone)
  end

private

  def set_mode
    return if (@mode = params[:mode]).in?(SUPPORTED_MODES)

    redirect_to pone_path(params[:id], mode: SUPPORTED_MODES.first)
  end
end
