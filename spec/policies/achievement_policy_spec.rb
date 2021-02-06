# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AchievementPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:achievement) { build(:achievement) }
  let(:pone) { build(:pone) }

  permissions :index? do
    it 'permits everyone' do
      expect(policy).to permit(nil, achievement)
        .and permit(pone, achievement)
    end
  end
end
