# frozen_string_literal: true

module Api
  module V1
    class SchemaController < ApplicationController
      SCHEMA_PATH   = Rails.root.join('schema').freeze
      OPEN_API_PATH = Rails.root.join('doc', 'api', 'open_api.json').freeze

      def index
        @files = Dir[SCHEMA_PATH.join('**', '*.schema.json')].map do |file|
          Pathname.new(file).relative_path_from(SCHEMA_PATH).to_s
        end

        @files = @files.group_by do |path|
          path.split('/')[0...-1]
        end
      end

      def show
        file_path = SCHEMA_PATH.join(params[:file]).expand_path
        return redirect_to('/404.html') unless file_path.to_s.starts_with?(SCHEMA_PATH.to_s) && File.exist?(file_path)

        render json: File.read(file_path)
      end

      def open_api
        render json: File.read(OPEN_API_PATH)
      end
    end
  end
end
