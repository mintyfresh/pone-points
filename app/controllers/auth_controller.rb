# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :set_return_path

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
end
