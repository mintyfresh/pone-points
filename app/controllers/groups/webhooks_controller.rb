# frozen_string_literal: true

module Groups
  class WebhooksController < ApplicationController
    before_action :set_group
    before_action :set_webhook, only: %i[show regenerate destroy]

    def index
      authorize(Webhook)
      @webhooks = policy_scope(@group.webhooks).order(:id)
    end

    def show
      authorize(@webhook)
    end

    def new
      authorize(Webhook)

      @form = CreateGroupWebhookForm.new
    end

    def create
      authorize(Webhook)

      @form = CreateGroupWebhookForm.new(create_webhooks_params)
      @form.owner        = current_pone
      @form.event_source = @group

      if (@webhook = @form.perform)
        flash[:show_signing_key] = true

        redirect_to group_webhook_path(@group, @webhook)
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def regenerate
      authorize(@webhook)

      @webhook.regenerate_signing_key
      flash[:show_signing_key] = true

      redirect_to group_webhook_path(@group, @webhook)
    end

    def destroy
      authorize(@webhook).destroy!

      redirect_to group_webhooks_path(@group)
    end

  private

    def set_group
      @group = Group.find_by!(slug: params[:group_slug])
      authorize(@group, :show?)
    end

    def set_webhook
      @webhook = @group.webhooks.find(params[:id])
    end

    def create_webhooks_params
      params.require(:create_group_webhook_form).permit(:name, :url, :events, events: [])
    end
  end
end
