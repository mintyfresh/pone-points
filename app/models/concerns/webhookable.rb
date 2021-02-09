# frozen_string_literal: true

module Webhookable
  extend ActiveSupport::Concern

  included do
    has_many :webhooks, as: :event_source, dependent: :destroy, inverse_of: :event_source
  end
end
