# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Achievements::TheRegularAchievementSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.points.create' }
  let(:payload) { { point: point, occurred_at: Time.current } }
  let(:point) { create(:point) }
  let(:achievement) { subscriber.achievement }

  it 'grants the "The Regular" achievement' do
    expect(achievement.name).to eq('The Regular')
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    it 'grants the achievement if the pone has given out points 3 days in a row' do
      create(:point, granted_by: point.granted_by, created_at: point.created_at - 1.day)
      create(:point, granted_by: point.granted_by, created_at: point.created_at - 2.days)
      expect { perform }.to change { point.granted_by.achievement_unlocked?(achievement) }.to(true)
    end

    it 'does not grant the achievement if the pone has given out points only 2 days in a row' do
      create(:point, granted_by: point.granted_by, created_at: point.created_at - 1.day)
      expect { perform }.not_to change { point.granted_by.achievement_unlocked?(achievement) }
    end

    it 'does not grant the achievement if the pone missed a day' do
      create(:point, granted_by: point.granted_by, created_at: point.created_at - 2.days)
      create(:point, granted_by: point.granted_by, created_at: point.created_at - 3.days)
      expect { perform }.not_to change { point.granted_by.achievement_unlocked?(achievement) }
    end

    it 'does not grant the achievement if other pones had given out some of the points' do
      create(:point, created_at: point.created_at - 1.day)
      create(:point, created_at: point.created_at - 2.days)
      expect { perform }.not_to change { point.granted_by.achievement_unlocked?(achievement) }
    end
  end
end
