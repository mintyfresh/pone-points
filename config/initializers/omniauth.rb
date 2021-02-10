# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [:post]

OmniAuth.config.on_failure = proc do |env|
  AuthController.action(:external_failure).call(env)
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord, ENV['DISCORD_CLIENT_ID'], ENV['DISCORD_CLIENT_SECRET'], scope: 'identify'
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
end
