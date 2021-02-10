# frozen_string_literal: true

class ExternalAuthError < ApplicationModel
  attribute :code, :string
  attribute :message, :string
end
