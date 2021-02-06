# frozen_string_literal: true

class AccountController < ApplicationController
  def integrations
    authorize(current_pone, :integrations?)
  end

  def change_password
    authorize(current_pone, :change_password?)
    @form = ChangePasswordForm.new
  end

  def do_change_password
    authorize(current_pone, :change_password?)
    @form = ChangePasswordForm.new(change_password_params)

    if @form.perform
      redirect_to current_pone
    else
      render 'change_password'
    end
  end

private

  def change_password_params
    params.require(:change_password_form).permit(:old_password, :new_password, :new_password_confirmation)
      .merge(pone: current_pone)
  end
end
