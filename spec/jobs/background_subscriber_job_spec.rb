# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BackgroundSubscriberJob, type: :job do
  subject(:job) { described_class.new }

  describe '#perform' do
    subject(:perform) { job.perform(subscriber_name, event, payload) }

    let(:subscriber_class) { class_spy('ApplicationSubscriber') }
    let(:subscriber) { instance_spy(subscriber_class) }

    let(:subscriber_name) { 'MockSubscriber' }
    let(:event) { 'app.mock.event' }
    let(:payload) { { pone: create(:pone), occurred_at: Time.current } }

    before(:each) do
      stub_const(subscriber_name, subscriber_class)
      allow(subscriber_class).to receive(:new).and_return(subscriber)
    end

    it 'instantiates the subscriber with the input data' do
      perform
      expect(subscriber_class).to have_received(:new).with(event, payload)
    end

    it 'runs the subscriber logic' do
      perform
      expect(subscriber).to have_received(:perform)
    end
  end
end
