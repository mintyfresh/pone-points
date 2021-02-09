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
require 'rails_helper'

RSpec.shared_examples_for Webhook, type: :model do
  it 'is invalid without an owner' do
    webhook.owner = nil
    expect(webhook).to be_invalid
  end

  it 'is invalid without an event source' do
    webhook.event_source = nil
    expect(webhook).to be_invalid
  end

  it 'is invalid without a name' do
    webhook.name = nil
    expect(webhook).to be_invalid
  end

  it 'is valid without any events' do
    webhook.events = []
    expect(webhook).to be_valid
  end

  it 'is invalid when some events are unsupported' do
    webhook.events << 'fake.event'
    expect(webhook).to be_invalid
  end

  it 'is invalid without a url' do
    webhook.url = nil
    expect(webhook).to be_invalid
  end

  it 'is invalid when the url is malformed' do
    webhook.url = 'fake-url'
    expect(webhook).to be_invalid
  end

  it 'is invalid when the url scheme is unsupported' do
    webhook.url = 'data://foo'
    expect(webhook).to be_invalid
  end

  it 'is invalid when the url has no host' do
    webhook.url = 'https://'
    expect(webhook).to be_invalid
  end
end
