# frozen_string_literal: true

module Account
  class ApiKeysController < ApplicationController
    before_action :set_api_key, only: :show

    def index
      authorize(ApiKey)
      @api_keys = policy_scope(current_pone.api_keys).order(:id)
    end

    def show
      authorize(@api_key)
    end

  private

    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end
  end
end
