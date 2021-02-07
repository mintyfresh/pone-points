# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :external

  before_action :set_return_path, except: :external

  def sign_in
    @form = SignInForm.new
  end

  def do_sign_in
    @form = SignInForm.new(sign_in_params)

    if (pone = @form.perform)
      self.current_pone = pone

      redirect_to(@return_path || pone)
    else
      render 'sign_in', status: :unprocessable_entity
    end
  end

  def sign_up
    @form = SignUpForm.new
  end

  def do_sign_up
    @form = SignUpForm.new(sign_up_params)

    if (pone = @form.perform)
      self.current_pone = pone

      redirect_to(@return_path || pone)
    else
      render 'sign_up', status: :unprocessable_entity
    end
  end

  def sign_out
    self.current_pone = nil
    redirect_to pones_path
  end

  def external
    if current_pone
      # Sign-in user completed OAuth, link accounts.
      external_auth_service.link_account(external_auth_hash, current_pone)
    elsif (pone = external_auth_service.sign_in(external_auth_hash))
      # Existing user completed OAuth, sign them in.
      self.current_pone = pone
    else
      # New user completed OAuth, start sign-up flow.
      sign_up_token = external_auth_service.generate_sign_up_token(external_auth_hash)
      return redirect_to external_sign_up_path(sign_up_token: sign_up_token)
    end

    redirect_to current_pone
  end

  def external_sign_up
    payload = external_auth_service.parse_sign_up_token(params[:sign_up_token])
    return redirect_to('/404.html') if payload.blank?

    @form = ExternalSignUpForm.new do |form|
      form.sign_up_token = params[:sign_up_token]
      form.name          = payload[:account_name]
    end
  end

  def do_external_sign_up
    @form = ExternalSignUpForm.new(external_sign_up_params)

    if (pone = @form.perform)
      self.current_pone = pone

      redirect_to current_pone
    else
      render 'external_sign_up', status: :unprocessable_entity
    end
  end

private

  def set_return_path
    return if (return_path = params[:return_path]).blank?
    return unless URI(return_path).relative?

    @return_path = return_path
  rescue URI::InvalidURIError
    Rails.logger.warn("Invalid return path URI: #{path.inspect}")
  end

  def sign_in_params
    params.require(:sign_in_form).permit(:name, :password)
  end

  def sign_up_params
    params.require(:sign_up_form).permit(:name, :password, :password_confirmation)
  end

  def external_sign_up_params
    params.require(:external_sign_up_form).permit(:sign_up_token, :name)
  end

  # @return [ExternalAuthService]
  def external_auth_service
    @external_auth_service ||= ExternalAuthService.new
  end

  # @return [Hash]
  def external_auth_hash
    @external_auth_hash ||= request.env['omniauth.auth']
  end
end
