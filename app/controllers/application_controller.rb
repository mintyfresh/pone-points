# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError do
    if current_pone.nil?
      redirect_to sign_in_path(return_path: request.path)
    elsif current_pone.role?(Roles::BANNED)
      redirect_to bans_path
    else
      redirect_to '/404.html'
    end
  end

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
