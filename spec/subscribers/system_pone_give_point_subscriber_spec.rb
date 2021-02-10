# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemPoneGivePointSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.pones.verify' }
  let(:payload) { { pone: pone, occurred_at: Time.current } }
  let(:pone) { create(:pone, :verified) }

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:system_pone) { Pone.find_by!(name: 'System Pone') }

    it 'adds a point to the verified pone' do
      expect { perform }.to change { pone.points.count }.by(1)
    end

    it 'grants the point from the system pone' do
      perform
      expect(pone.points.last).to have_attributes(
        granted_by: system_pone, count: 1
      )
    end
  end
end
