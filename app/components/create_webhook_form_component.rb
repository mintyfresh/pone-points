# frozen_string_literal: true

class CreateWebhookFormComponent < ApplicationComponent
  # @param form [CreateWebhookForm]
  # @param url [String]
  def initialize(form:, url:)
    @form = form
    @url  = url
  end
end
