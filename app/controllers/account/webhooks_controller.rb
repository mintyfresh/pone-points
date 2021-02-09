# frozen_string_literal: true

module Account
  class WebhooksController < ApplicationController
    before_action :set_webhook, only: %i[show regenerate destroy]

    def index
      authorize(Webhook)
      @webhooks = policy_scope(current_pone.webhooks).order(:id)
    end

    def show
      authorize(@webhook)
    end

    def new
      authorize(Webhook)

      @form = CreatePoneWebhookForm.new
    end

    def create
      authorize(Webhook)

      @form = CreatePoneWebhookForm.new(create_webhooks_params)
      @form.owner        = current_pone
      @form.event_source = current_pone

      if (webhook = @form.perform)
        flash[:show_signing_key] = true

        redirect_to account_webhook_path(webhook)
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def regenerate
      authorize(@webhook)

      @webhook.regenerate_signing_key
      flash[:show_signing_key] = true

      redirect_to account_webhook_path(@webhook)
    end

    def destroy
      authorize(@webhook).destroy!

      redirect_to account_webhooks_path
    end

  private

    def set_webhook
      @webhook = PoneWebhook.find(params[:id])
    end

    def create_webhooks_params
      params.require(:create_pone_webhook_form).permit(:name, :url, :events, events: [])
    end
  end
end
