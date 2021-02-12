# frozen_string_literal: true

module Groups
  class ImageController < ApplicationController
    before_action :set_group

    def edit
      authorize(@group, :update?)

      @form = UploadGroupImageForm.new(group: @group)
    end

    def update
      authorize(@group, :update?)

      @form = UploadGroupImageForm.new(group: @group)
      @form.attributes = permitted_attributes(UploadGroupImageForm, :update_image)

      if @form.perform
        redirect_to @group
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    def remove
      authorize(@group, :update?)
      @group.image.purge

      redirect_to @group
    end

  private

    def set_group
      @group = Group.find_by!(slug: params[:group_slug])
    end
  end
end
