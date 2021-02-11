# frozen_string_literal: true

module Account
  class ApiKeysController < ApplicationController
    before_action :set_api_key, only: %i[show regenerate revoke]

    def index
      authorize(ApiKey)
      @api_keys = policy_scope(current_pone.api_keys).order(:id)
    end

    def show
      authorize(@api_key)
    end

    def new
      authorize(ApiKey)
      @form = CreateApiKeyForm.new
    end

    def create
      authorize(ApiKey)

      @form = CreateApiKeyForm.new(permitted_attributes(CreateApiKeyForm))
      @form.pone = current_pone

      if (api_key = @form.perform)
        flash[:show_token] = true

        redirect_to account_api_key_path(api_key)
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def regenerate
      authorize(@api_key)

      @api_key.regenerate_token
      flash[:show_token] = true

      redirect_to account_api_key_path(@api_key)
    end

    def revoke
      authorize(@api_key).revoked!

      redirect_to account_api_key_path(@api_key)
    end

  private

    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end
  end
end
