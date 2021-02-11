# frozen_string_literal: true

Rails.application.config.middleware.insert_before(0, Rack::Cors) do
  allow do
    origins '*'
    resource '/api/v1/schema/open_api.json',
             methods: %i[get options]
  end
end
