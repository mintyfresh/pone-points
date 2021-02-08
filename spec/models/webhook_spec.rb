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
require 'rails_helper'

RSpec.describe Webhook, type: :model do
  subject(:webhook) { build(:webhook) }

  it 'has a valid factory' do
    expect(webhook).to be_valid
  end

  it 'is invalid without a pone' do
    webhook.pone = nil
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
