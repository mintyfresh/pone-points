# frozen_string_literal: true

class ExternalAuthComponent < ApplicationComponent
  # @return [ExternalAuthError, nil]
  def external_auth_error
    return @external_auth_error if defined?(@external_auth_error)

    @external_auth_error = (data = flash[:external_auth_error]) && ExternalAuthError.new(data)
  end
end
