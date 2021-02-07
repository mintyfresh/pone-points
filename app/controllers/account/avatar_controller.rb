# frozen_string_literal: true

module Account
  class AvatarController < ApplicationController
    def edit
      authorize(current_pone, :update?)
      @form = UploadAvatarForm.new do |form|
        form.pone   = current_pone
        form.avatar = current_pone.avatar
      end
    end

    def update
      authorize(current_pone, :update?)
      @form = UploadAvatarForm.new(update_params) do |form|
        form.pone = current_pone
      end

      if @form.perform
        redirect_to account_avatar_path
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    def remove
      authorize(current_pone, :update?)
      current_pone.avatar.purge

      redirect_to account_avatar_path
    end

  private

    def update_params
      params.require(:upload_avatar_form).permit(:avatar)
    end
  end
end
