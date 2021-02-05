# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    def generates_slug_from(*fields)
      before_save do
        self.slug = fields.map { |field| send(field) }.join('-').parameterize
      end
    end
  end

  # @return [String, nil]
  def to_param
    slug
  end
end
