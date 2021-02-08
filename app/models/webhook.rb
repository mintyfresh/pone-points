# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id          :bigint           not null, primary key
#  pone_id     :bigint           not null
#  signing_key :string           not null
#  events      :string           not null, is an Array
#  url         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_webhooks_on_pone_id  (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
class Webhook < ApplicationRecord
  SUPPORTED_EVENTS = %w[app.points.create].freeze

  belongs_to :pone, inverse_of: :webhooks

  has_secure_token :signing_key, length: 80

  validates :url, presence: true, url: true
  validate :events_are_supported

  before_save :remove_duplicate_events, if: :events_changed?

  scope :where_event, -> (event) { where(%{? = ANY(#{quoted_table_name}."events")}, event) }

private

  # @return [void]
  def events_are_supported
    return if (unsupported_events = events - SUPPORTED_EVENTS).none?

    errors.add(:events, :unsupported, events: unsupported_events.uniq.to_sentence)
  end

  # @return [void]
  def remove_duplicate_events
    self.events = events.uniq.sort
  end
end
