# frozen_string_literal: true

require 'acceptance_helper'

RSpec.resource 'Points', type: :acceptance do
  let(:authorization_header) { "Api-Key #{token}" }
  let(:token) { api_key.token }
  let(:api_key) { create(:api_key) }

  authentication :apiKey, :authorization_header, name: 'Authorization'
  header 'Content-Type', 'application/json'

  parameter :pone_slug, "The pone's slug", required: true, type: :string

  get '/api/v1/pones/:pone_slug/points.json' do
    let(:pone_slug) { pone.slug }
    let(:pone) { create(:pone, :with_points) }

    parameter :page, 'The page number', type: :integer
    parameter :count, 'The number of points to show per page', type: :integer

    example_request "Listing a pone's points" do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:points)
      expect(response_body).to include_json(
        points: pone.points.first(25).map { |point| { id: point.id } }
      )
    end
  end

  get '/api/v1/pones/:pone_slug/points/granted.json' do
    let(:pone_slug) { pone.slug }
    let(:pone) { create(:pone, :with_granted_points) }

    example_request 'Listing the points a pone has given out' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:points)
      expect(response_body).to include_json(
        points: pone.granted_points.first(25).map { |point| { id: point.id } }
      )
    end
  end

  get '/api/v1/pones/:pone_slug/points/:id.json' do
    let(:pone_slug) { pone.slug }
    let(:id) { point.id }
    let(:pone) { point.pone }
    let(:point) { create(:point) }

    parameter :id, 'The ID of the point record', required: true, type: :integer

    example_request 'Requesting a specific point entry' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:point)
      expect(response_body).to include_json(
        point: { id: id }
      )
    end
  end

  post '/api/v1/pones/:pone_slug/points/give.json' do
    let(:pone_slug) { pone.slug }
    let(:pone) { create(:pone) }

    with_options scope: :point do
      parameter :count, 'The number of points to give', required: true, type: :integer, minimum: 1, maximum: 5
      parameter :message, 'A nice message for the pone', type: :string
    end

    let(:raw_post) { params.to_json }

    context 'with valid input' do # rubocop:disable RSpec/EmptyExampleGroup, RSpec/MultipleMemoizedHelpers
      let(:count) { rand(1..3) }
      let(:message) { Faker::Hipster.sentence }

      example_request 'Giving points to a pone' do
        expect(response_status).to eq(201)
        expect(response_body).to match_schema(:point)
        expect(response_body).to include_json(
          point: {
            count:   count,
            message: message,
            links:   {
              pone:       api_v1_pone_path(pone, format: :json),
              granted_by: api_v1_pone_path(api_key.pone, format: :json)
            }
          }
        )
      end
    end

    context 'with invalid input' do # rubocop:disable RSpec/EmptyExampleGroup, RSpec/MultipleMemoizedHelpers
      let(:count) { -1 }
      let(:message) { Faker::Hipster.sentence }

      example_request 'Giving points to a pone [invalid]' do
        expect(response_status).to eq(422)
        expect(response_body).to include_json(
          errors: {
            count: ['must be greater than 0']
          }
        )
      end
    end
  end
end
