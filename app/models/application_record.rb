# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  include Publisher

  self.abstract_class = true

  after_commit :publish_record_created,   on: :create
  after_commit :publish_record_updated,   on: :update
  after_commit :publish_record_destroyed, on: :destroy

protected

  # @param event [Symbol, String]
  # @param payload [Hash]
  # @return [voi]
  def publish(event, **payload)
    super("app.#{model_name.plural}.#{event}", model_name.singular.to_sym => self, **payload)
  end

  # @return [void]
  def publish_record_created
    publish(:create)
  end

  # @return [void]
  def publish_record_updated
    publish(:update)
  end

  # @return [void]
  def publish_record_destroyed
    publish(:destroy)
  end
end
