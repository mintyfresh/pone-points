# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BanPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:ban) { build(:ban, pone: pone) }
  let(:pone) { build(:pone) }

  permissions :index? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, Ban)
    end

    it 'permits authenticated pones' do
      expect(policy).to permit(pone, Ban)
    end
  end
end
