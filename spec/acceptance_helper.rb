# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

module RspecApiDocumentation
  class RackTestClient < ClientBase
    def response_body
      last_response.body.encode('utf-8')
    end
  end
end

RspecApiDocumentation.configure do |config|
  config.format = %i[json open_api]

  config.keep_source_order = true

  config.request_headers_to_include = %w[
    Authorization
    Content-Type
  ]

  config.response_headers_to_include = %w[
    Content-Type
    Content-Length
  ]
end
