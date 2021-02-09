# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id                :bigint           not null, primary key
#  owner_id          :bigint           not null
#  name              :string           not null
#  signing_key       :string           not null
#  events            :string           not null, is an Array
#  url               :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string           not null
#  event_source_type :string           not null
#  event_source_id   :bigint           not null
#
# Indexes
#
#  index_webhooks_on_event_source  (event_source_type,event_source_id)
#  index_webhooks_on_owner_id      (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => pones.id)
#
class Webhook < ApplicationRecord
  NAME_MAX_LENGTH   = 50
  EVENTS_I18N_SCOPE = 'webhooks.events'

  belongs_to :owner, class_name: 'Pone', inverse_of: :owned_webhooks
  belongs_to :event_source, polymorphic: true

  has_secure_token :signing_key, length: 80

  validates :name, presence: true, length: { maximum: NAME_MAX_LENGTH }
  validates :url, presence: true, url: true
  validates :events, subset: { of: :supported_events }

  before_save :remove_duplicate_events, if: :events_changed?

  scope :where_event, -> (event) { where(%{? = ANY(#{quoted_table_name}."events")}, event) }

  # @param event [String]
  # @return [String]
  def self.name_for_event(event)
    I18n.t(event.tr('.', '/'), scope: EVENTS_I18N_SCOPE)
  end

  # @return [Class]
  def self.policy_class
    WebhookPolicy
  end

  # @abstract
  # @return [Array<String>]
  def self.supported_events
    raise NotImplementedError, "#{self.class.name} does not implement `#{__method__}`."
  end

  # @!method supported_events
  #   @return [Array<String>]
  delegate :supported_events, to: :class

private

  # @return [void]
  def remove_duplicate_events
    self.events = events.uniq.sort
  end
end
