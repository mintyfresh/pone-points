# frozen_string_literal: true

require 'rails_helper'
require_relative 'create_webhook_form_examples'

RSpec.describe CreateGroupWebhookForm, type: :form do
  subject(:form) { described_class.new(**input, event_source: event_source, owner: owner) }

  let(:input) { attributes_for(:create_group_webhook_input) }
  let(:event_source) { create(:group) }
  let(:owner) { create(:pone) }

  before(:each) do
    event_source.add_member(owner)
  end

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it_behaves_like CreateWebhookForm

  it 'is invalid when the group has too many webhooks' do
    create_list(:group_webhook, described_class::MAX_WEBHOOKS_PER_GROUP, event_source: event_source)
    expect(form).to be_invalid
  end

  it 'is invalid when the owner is not a member of the group' do
    event_source.remove_member(owner)
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the newly created group webhook' do
      expect(perform).to be_a(GroupWebhook)
        .and be_persisted
        .and have_attributes(owner: owner, event_source: event_source)
    end

    it 'saves the webhook configuration on the webhook' do
      expect(perform).to have_attributes(
        name:   input[:name],
        events: input[:events].uniq.sort,
        url:    input[:url]
      )
    end
  end
end
