# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Pones::Points', type: :request do
  let(:headers) { { 'Authorization' => "Api-Key #{token}" } }
  let(:token) { api_key.token }
  let(:api_key) { create(:api_key) }

  describe 'GET /api/v1/pones/:pone_slug/points' do
    let(:path) { api_v1_pone_points_path(pone) }
    let(:pone) { create(:pone, :with_points) }

    it 'returns ok' do
      get path, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns a list of the pone's points" do
      get path, headers: headers

      expect(response.body).to include_json(
        points: pone.points.map { |point| { id: point.id } }
      )
    end

    context 'without a valid api key' do
      let(:token) { '' }

      it 'returns unauthorized' do
        get path, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/pones/:pone_slug/points/give' do
    let(:path) { give_api_v1_pone_points_path(pone) }
    let(:pone) { create(:pone, :verified) }
    let(:input) { { count: 1, message: Faker::Hipster.sentence } }

    it 'returns created' do
      post path, params: { point: input }, headers: headers

      expect(response).to have_http_status(:created)
    end

    it 'returns the newly created point' do
      post path, params: { point: input }, headers: headers

      expect(response.body).to include_json(
        point: { count: input[:count], message: input[:message] }
      )
    end

    context 'without a valid api key' do
      let(:token) { '' }

      it 'returns unauthorized' do
        post path, params: { point: input }, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not add any points to the pone' do
        expect do
          post path, params: { point: input }, headers: headers
        end.not_to change { pone.points.count }
      end
    end
  end
end
