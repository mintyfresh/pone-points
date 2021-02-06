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
      render 'sign_in'
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
      render 'sign_up'
    end
  end

  def sign_out
    self.current_pone = nil
    redirect_to pones_path
  end

  def external
    self.current_pone = authenticate_external_pone

    redirect_to current_pone
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

  # @return [Pone]
  def authenticate_external_pone
    params = external_auth_params

    Pone.find_or_create_pone_by_external_id!(external_credential_class, params.uid) do |pone|
      pone.name = params.info.name
    end
  end

  # @return [Class<PoneCredential>]
  def external_credential_class
    case external_auth_params.provider
    when 'discord'
      PoneDiscordCredential
    else
      raise ArgumentError, "Unsupported OAuth provider: #{external_auth_params.provider}"
    end
  end

  def external_auth_params
    @external_auth_params ||= request.env['omniauth.auth']
  end
end
