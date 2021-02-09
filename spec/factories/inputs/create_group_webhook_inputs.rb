# frozen_string_literal: true

FactoryBot.define do
  factory :create_group_webhook_input, parent: :create_webhook_input do
    events { GroupWebhook.supported_events.sample(3) }
  end
end
