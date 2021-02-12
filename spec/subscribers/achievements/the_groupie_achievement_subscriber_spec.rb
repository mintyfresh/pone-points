# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Achievements::TheGroupieAchievementSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.memberships.create' }
  let(:payload) { { membership: membership, occurred_at: Time.current } }
  let(:membership) { create(:membership) }
  let(:achievement) { subscriber.achievement }

  it 'grants the "The Groupie" achievement' do
    expect(achievement.name).to eq('The Groupie')
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    it 'grants the achievement to the pone' do
      expect { perform }.to change { membership.member.achievement_unlocked?(achievement) }.to(true)
    end
  end
end
