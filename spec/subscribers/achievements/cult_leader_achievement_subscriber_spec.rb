# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Achievements::CultLeaderAchievementSubscriber, type: :subscriber do
  subject(:subscriber) { described_class.new(event, payload) }

  let(:event) { 'app.memberships.create' }
  let(:payload) { { membership: membership, occurred_at: Time.current } }
  let(:membership) { create(:membership, group: group) }
  let(:group) { create(:group) }
  let(:achievement) { subscriber.achievement }

  it 'grants the "Cult Leader" achievement' do
    expect(achievement.name).to eq('Cult Leader')
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    it 'grants the achievement to the owner once 9 other pones join the group' do
      create_list(:membership, 10 - group.members_count, group: group)
      expect { perform }.to change { group.owner.achievement_unlocked?(achievement) }.to(true)
    end

    it "doesn't grant the achievement if fewer than 10 total pones are in the group" do
      create_list(:membership, 10 - group.members_count - 1, group: group)
      expect { perform }.to change { group.owner.achievement_unlocked?(achievement) }.to(true)
    end
  end
end
