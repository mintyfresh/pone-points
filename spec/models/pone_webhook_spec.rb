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

RSpec.describe PoneWebhook, type: :model do
  subject(:webhook) { build(:pone_webhook) }

  it 'has a valid factory' do
    expect(webhook).to be_valid
      .and be_a(described_class)
      .and have_attributes(type: described_class.sti_name)
  end

  it_behaves_like Webhook
end
