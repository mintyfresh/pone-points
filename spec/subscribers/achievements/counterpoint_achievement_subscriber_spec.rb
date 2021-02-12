# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Achievements::CounterpointAchievementSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.points.create' }
  let(:payload) { { point: point, occurred_at: Time.current } }
  let(:point) { create(:point) }
  let(:achievement) { subscriber.achievement }

  it 'grants the "Counterpoint" achievement' do
    expect(achievement.name).to eq('Counterpoint')
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let!(:countered_point) { create(:point, pone: point.granted_by, granted_by: point.pone, created_at: 5.minutes.ago) }

    it 'grants the counterpoint achievement to the granter of the pone' do
      expect { perform }.to change { point.granted_by.achievement_unlocked?(achievement) }.to(true)
    end

    it "doesn't grant the achievement if the countered point was given to a different pone" do
      countered_point.update!(pone: create(:pone))
      expect { perform }.not_to change { point.granted_by.unlocked_achievements.count }
    end

    it "doesn't grant the achievement if the countered point was given by a different pone" do
      countered_point.update!(granted_by: create(:pone))
      expect { perform }.not_to change { point.granted_by.unlocked_achievements.count }
    end

    it "doesn't grant the achievement if another point was given in the interrim" do
      create(:point, granted_by: countered_point.granted_by, created_at: 3.minutes.ago)
      expect { perform }.not_to change { point.granted_by.unlocked_achievements.count }
    end
  end
end
