# frozen_string_literal: true

module FactoryBot
  class InputGenerator < Rails::Generators::NamedBase
    INPUT_NAME_SUFFIX = '_input'

    source_root File.expand_path('templates', __dir__)

    def create_input
      template('inputs.rb.erb', factory_file_path)
    end

  private

    # @return [String]
    def input_name
      name.underscore.chomp(INPUT_NAME_SUFFIX) + INPUT_NAME_SUFFIX
    end

    # @return [String]
    def factory_file_path
      File.join('spec', 'factories', 'inputs', factory_file_name)
    end

    # @return [String]
    def factory_file_name
      "#{input_name.pluralize}.rb"
    end
  end
end
