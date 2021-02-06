# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PointPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:point) { build(:point) }
  let(:pone) { build(:pone) }

  permissions :index?, :show? do
    it 'permits everyone' do
      expect(policy).to permit(nil, point)
        .and permit(pone, point)
    end
  end
end
