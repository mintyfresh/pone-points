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
class PoneWebhook < Webhook
  validates :event_source, type: { name: 'Pone' }

  # @return [Array<String>]
  def self.supported_events
    %w[app.points.give app.points.receive]
  end
end
