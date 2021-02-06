# frozen_string_literal: true

class ApiKeyListComponent < ApplicationComponent
  # @param api_keys [Array<ApiKey>]
  def initialize(api_keys:)
    @api_keys = api_keys
  end
end
