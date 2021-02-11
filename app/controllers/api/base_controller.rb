# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    API_KEY_AUTHORIZATION = 'Api-Key'

    include Kaminari::Helpers::UrlHelper
    include Pundit

    before_action :verify_api_key

    after_action :increment_api_key_requests_count

    # @return [ApiKey, nil]
    def api_key
      return @api_key if defined?(@api_key)

      @api_key = ApiKey.find_by_token(api_key_token)
    end

    # @return [Pone, nil]
    def pundit_user
      api_key&.pone
    end

  protected

    # @return [String, nil]
    def api_key_token
      authorization = request.headers['Authorization']
      return if authorization.blank?

      type, token = authorization.split(' ', 2)
      return if type != API_KEY_AUTHORIZATION || token.blank?

      token
    end

  private

    # @return [void]
    def verify_api_key
      head :unauthorized if api_key.nil?
    end

    # @return [void]
    def increment_api_key_requests_count
      api_key&.increment!(:requests_count, touch: :last_request_at)
    end
  end
end
