# frozen_string_literal: true

require 'rails_helper'
require_relative 'create_webhook_form_examples'

RSpec.describe CreatePoneWebhookForm, type: :form do
  subject(:form) { described_class.new(**input, event_source: event_source, owner: owner) }

  let(:input) { attributes_for(:create_pone_webhook_input) }
  let(:event_source) { owner }
  let(:owner) { create(:pone) }

  it 'has a valid input factory' do
    expect(form).to be_valid
  end

  it_behaves_like CreateWebhookForm

  it 'is invalid when the pone has too many webhooks' do
    create_list(:pone_webhook, described_class::MAX_WEBHOOKS_PER_PONE, event_source: event_source)
    expect(form).to be_invalid
  end

  describe '#perform' do
    subject(:perform) { form.perform }

    it 'returns the newly created pone webhook' do
      expect(perform).to be_a(PoneWebhook)
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
