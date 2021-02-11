# frozen_string_literal: true

require 'acceptance_helper'

RSpec.resource 'Groups', type: :acceptance do
  let(:authorization_header) { "Api-Key #{token}" }
  let(:token) { api_key.token }
  let(:api_key) { create(:api_key) }

  authentication :apiKey, :authorization_header, name: 'Authorization'
  header 'Content-Type', 'application/json'

  get '/api/v1/groups.json' do
    before(:each) do
      create_list(:group, 3)
    end

    parameter :page, 'The page number', type: :integer
    parameter :count, 'The number of groups to show per page', type: :integer

    example_request 'Listing groups' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:groups)
      expect(response_body).to include_json(
        groups: Group.first(25).map { |group| { slug: group.slug } }
      )
    end
  end

  get '/api/v1/groups/:slug.json' do
    let(:slug) { group.slug }
    let(:group) { create(:group) }

    parameter :slug, required: true, type: :string

    example_request 'Requesting a specific group' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:group)
      expect(response_body).to include_json(
        group: { slug: slug, description: group.description }
      )
    end
  end

  get '/api/v1/groups/:slug/members.json' do
    let(:slug) { group.slug }
    let(:group) { create(:group, :with_members) }

    parameter :slug, required: true, type: :string
    parameter :page, 'The page number', type: :integer
    parameter :count, 'The number of members to show per page', type: :integer

    example_request 'Requesting all of the members of a group' do
      expect(response_status).to eq(200)
      expect(response_body).to match_schema(:members)
      expect(response_body).to include_json(
        members: group.members.order(:id).first(25).map { |member| { slug: member.slug } }
      )
    end
  end
end
