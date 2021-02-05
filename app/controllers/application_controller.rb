# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  # @return [Pone, nil]
  def current_pone
    return @current_pone if defined?(@current_pone)

    @current_pone = (pone_id = session[:pone_id]) && Pone.find_by(id: pone_id)
  end

  # @param value [Pone, nil]
  # @return [void]
  def current_pone=(value)
    @current_pone     = value
    session[:pone_id] = value&.id
  end

  helper_method :current_pone

  def pundit_user
    current_pone
  end
end
