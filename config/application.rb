# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_storage/engine'
require 'sprockets/railtie'
require 'view_component/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PonePoints
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Disable ActionView's field wrapper divs as they interfere with Bootstrap.
    config.action_view.field_error_proc = proc { |html_tag| html_tag }

    # Load translations from subdirectories of `config/locales` as well.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # Dump structure file in PostgreSQL native format.
    config.active_record.schema_format = :sql

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.orm                 :active_record
      g.fixture_replacement :factory_bot
      g.test_framework      :rspec, view_specs: false, component_specs: false
      g.assets              false
      g.helper              false
    end
  end
end
