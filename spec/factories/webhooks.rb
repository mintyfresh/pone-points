# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  pone_id    :bigint           not null
#  events     :string           not null, is an Array
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_webhooks_on_pone_id  (pone_id)
#
# Foreign Keys
#
#  fk_rails_...  (pone_id => pones.id)
#
FactoryBot.define do
  factory :webhook do
    association :pone, strategy: :build

    events { Webhook::SUPPORTED_EVENTS.sample(3) }
    url { Faker::Internet.url }
  end
end
