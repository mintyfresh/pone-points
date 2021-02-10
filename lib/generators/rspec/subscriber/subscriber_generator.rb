# frozen_string_literal: true

module Rspec
  class SubscriberGenerator < Rails::Generators::NamedBase
    CLASS_NAME_SUFFIX = 'Subscriber'
    FILE_NAME_SUFFIX  = '_subscriber'

    source_root File.expand_path('templates', __dir__)

    def create_subscriber
      template('subscriber_spec.rb.erb', subscriber_file_path)
    end

  private

    # @return [String]
    def subscriber_class_name
      name.camelize.chomp(CLASS_NAME_SUFFIX) + CLASS_NAME_SUFFIX
    end

    # @return [String]
    def subscriber_file_path
      File.join('spec', 'subscribers', subscriber_file_name)
    end

    # @return [String]
    def subscriber_file_name
      "#{name.underscore.chomp(FILE_NAME_SUFFIX)}#{FILE_NAME_SUFFIX}_spec.rb"
    end
  end
end
