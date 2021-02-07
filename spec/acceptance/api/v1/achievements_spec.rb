# frozen_string_literal: true

require 'acceptance_helper'

RSpec.resource 'Achievements', type: :acceptance do
  let(:authorization_header) { "Api-Key #{token}" }
  let(:token) { api_key.token }
  let(:api_key) { create(:api_key) }

  header 'Authorization', :authorization_header
  header 'Content-Type', 'application/json'

  parameter :pone_slug, "The pone's slug", required: true

  get '/api/v1/pones/:pone_slug/achievements.json' do
    let(:pone_slug) { pone.slug }
    let(:pone) { create(:pone, :with_achievements) }

    example_request "Listing a pone's achievements" do
      expect(response_status).to eq(200)
      expect(response_body).to include_json(
        achievements: pone.achievements.first(25).map { |achievement| { id: achievement.id } }
      )
    end
  end
end
