# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Achievements::AGoodPoneAchievementSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.points.create' }
  let(:payload) { { point: point, occurred_at: Time.current } }
  let(:point) { create(:point) }
  let(:achievement) { subscriber.achievement }

  it 'grants the "A Good Pone" achievement' do
    expect(achievement.name).to eq('A Good Pone')
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    it 'grants the achievement to the pone' do
      expect { perform }.to change { point.granted_by.achievement_unlocked?(achievement) }.to(true)
    end
  end
end
