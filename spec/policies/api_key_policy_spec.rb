# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKeyPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:api_key) { build(:api_key) }
  let(:pone) { api_key.pone }
  let(:other_pone) { build(:pone) }

  permissions :index? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, ApiKey)
    end

    it 'permits authenticated pones' do
      expect(policy).to permit(pone, ApiKey)
    end
  end

  permissions :create? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, ApiKey)
    end

    it 'permits authenticated pones' do
      expect(policy).to permit(pone, ApiKey)
    end

    it 'does not permit banned pones' do
      pone.add_role(Roles::BANNED)
      expect(policy).not_to permit(pone, ApiKey)
    end
  end

  permissions :show?, :regenerate?, :revoke? do
    it 'does not permit guests' do
      expect(policy).not_to permit(nil, api_key)
    end

    it 'permits the owner of the api key' do
      expect(policy).to permit(pone, api_key)
    end

    it 'does not permit other pones' do
      expect(policy).not_to permit(other_pone, api_key)
    end
  end
end
