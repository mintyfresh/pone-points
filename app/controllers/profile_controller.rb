# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :verify_current_pone

  def integrations
    # Nothing to do.
  end

  def change_password
    @form = ChangePasswordForm.new
  end

  def do_change_password
    @form = ChangePasswordForm.new(change_password_params)

    if @form.perform
      redirect_to current_pone
    else
      render 'change_password'
    end
  end

private

  def verify_current_pone
    redirect_to(sign_up_path) if current_pone.nil?
  end

  def change_password_params
    params.require(:change_password_form).permit(:old_password, :new_password, :new_password_confirmation)
      .merge(pone: current_pone)
  end
end
