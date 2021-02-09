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
FactoryBot.define do
  factory :pone_webhook, class: 'PoneWebhook', parent: :webhook do
    association :event_source, factory: :pone, strategy: :build

    type { 'PoneWebhook' }
    events { PoneWebhook.supported_events.sample(3) }
  end
end
