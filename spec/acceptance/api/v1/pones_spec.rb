# frozen_string_literal: true

require 'acceptance_helper'

RSpec.resource 'Pones', type: :acceptance do
  let(:authorization_header) { "Api-Key #{token}" }
  let(:token) { api_key.token }
  let(:api_key) { create(:api_key) }

  header 'Authorization', :authorization_header
  header 'Content-Type', 'application/json'

  get '/api/v1/pones.json' do
    before(:each) do
      create_list(:pone, 5)
    end

    example_request 'Listing pones' do
      expect(response_status).to eq(200)
      expect(response_body).to include_json(
        pones: Pone.first(25).map { |pone| { slug: pone.slug } }
      )
    end
  end

  get '/api/v1/pones/:slug.json' do
    let(:slug) { pone.slug }
    let(:pone) { create(:pone, :with_avatar) }

    parameter :slug, required: true

    example_request 'Requesting a specific pone' do
      expect(response_status).to eq(200)
      expect(response_body).to include_json(
        pone: { slug: slug }
      )
    end
  end

  get '/api/v1/pones/me.json' do
    with_options scope: :pone do
      response_field :giftable_points_count, 'The remaining number of points left to give out today'
      response_field :daily_giftable_points_count, 'The total number of points you can give out each day'
    end

    example_request 'Requesting additional information about your own pone' do
      expect(response_status).to eq(200)
      expect(response_body).to include_json(
        pone: {
          slug:                        api_key.pone.slug,
          giftable_points_count:       api_key.pone.giftable_points_count,
          daily_giftable_points_count: api_key.pone.daily_giftable_points_count
        }
      )
    end
  end
end
