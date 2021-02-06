# frozen_string_literal: true

class ApplicationBlueprint < Blueprinter::Base
  class Helpers
    include Rails.application.routes.url_helpers
  end

  # @return [Helpers]
  def self.helpers
    @helpers ||= Helpers.new
  end
end
