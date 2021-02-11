# frozen_string_literal: true

require 'acceptance_helper'

RSpec.resource 'Pones', type: :acceptance do
  let(:authorization_header) { "Api-Key #{token}" }
  let(:token) { api_key.token }
  let(:api_key) { create(:api_key) }

  authentication :apiKey, :authorization_header, name: 'Authorization'
  header 'Content-Type', 'application/json'

  get '/api/v1/pones.json' do
    before(:each) do
      create_list(:pone, 5)
    end

    parameter :page, 'The page number', type: :integer
    parameter :count, 'The number of pones to show per page', type: :integer

    example_request 'Listing pones' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:pones)
      expect(response_body).to include_json(
        pones: Pone.first(25).map { |pone| { slug: pone.slug } }
      )
    end
  end

  get '/api/v1/pones/:slug.json' do
    let(:slug) { pone.slug }
    let(:pone) { create(:pone, :with_avatar) }

    parameter :slug, required: true, type: :string

    example_request 'Requesting a specific pone' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:pone)
      expect(response_body).to include_json(
        pone: { slug: slug }
      )
    end
  end

  get '/api/v1/pones/me.json' do
    with_options scope: :pone do
      response_field :giftable_points_count, 'The remaining number of points left to give out today'
      response_field :daily_giftable_points_count, 'The total number of points you can give out each day'
      response_field :bonus_points_count, 'Additional, one-time use points that can be given to pones'
    end

    example_request 'Requesting additional information about your own pone' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:me)
      expect(response_body).to include_json(
        pone: {
          slug:                        api_key.pone.slug,
          giftable_points_count:       api_key.pone.giftable_points_count,
          daily_giftable_points_count: api_key.pone.daily_giftable_points_count,
          bonus_points_count:          api_key.pone.bonus_points_count
        }
      )
    end
  end

  get '/api/v1/pones/:slug/groups.json' do
    let(:slug) { pone.slug }
    let(:pone) { create(:pone, :with_groups) }

    parameter :slug, required: true, type: :string
    parameter :page, 'The page number', type: :integer
    parameter :count, 'The number of groups to show per page', type: :integer

    example_request "Requesting all of a pone's groups" do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:groups)
      expect(response_body).to include_json(
        groups: pone.groups.order(:id).first(25).map { |group| { slug: group.slug } }
      )
    end
  end
end
