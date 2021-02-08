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
      @form = CreateWebhookForm.new
    end

    def create
      authorize(Webhook)
      @form = CreateWebhookForm.new(create_webhooks_params) do |form|
        form.pone = current_pone
      end

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
      @webhook = Webhook.find(params[:id])
    end

    def create_webhooks_params
      params.require(:create_webhook_form).permit(:name, :url, :events, events: [])
    end
  end
end
