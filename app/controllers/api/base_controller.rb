# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    API_KEY_AUTHORIZATION = 'Api-Key'

    # @return [ApiKey, nil]
    def api_key
      return @api_key if defined?(@api_key)

      @api_key = ApiKey.find_by_token(api_key_token)
    end

  private

    # @return [String, nil]
    def api_key_token
      authorization = request.headers['Authorization']
      return if authorization.blank?

      type, token = authorization.split(' ', 2)
      return if type != API_KEY_AUTHORIZATION || token.blank?

      token
    end
  end
end
