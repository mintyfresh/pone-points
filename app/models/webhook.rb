# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id          :bigint           not null, primary key
#  pone_id     :bigint           not null
#  name        :string           not null
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
  NAME_MAX_LENGTH  = 50
  SUPPORTED_EVENTS = %w[app.points.create].freeze

  belongs_to :pone, inverse_of: :webhooks

  has_secure_token :signing_key, length: 80

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :url, presence: true, url: true
  validates :events, subset: { of: SUPPORTED_EVENTS }

  before_save :remove_duplicate_events, if: :events_changed?

  scope :where_event, -> (event) { where(%{? = ANY(#{quoted_table_name}."events")}, event) }

private

  # @return [void]
  def remove_duplicate_events
    self.events = events.uniq.sort
  end
end
