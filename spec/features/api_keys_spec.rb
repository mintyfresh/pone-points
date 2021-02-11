# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiKeys', type: :feature do
  let(:owner) { create(:pone, :verified) }

  it 'allows the pone to view API keys on their account' do
    sign_in_to_pone(owner)
    api_keys = create_list(:api_key, 5, pone: owner)

    visit '/account/api_keys'

    api_keys.each do |api_key|
      expect(page).to have_link(api_key.name, href: "/account/api_keys/#{api_key.id}")
    end
  end

  it 'allows the pone to create an API key' do
    sign_in_to_pone(owner)

    visit '/account/api_keys'
    click_on 'Create API Key'

    expect(page).to have_current_path('/account/api_keys/new')

    within '#new_api_key_form' do
      fill_in 'Name', with: 'Test API Key'
      fill_in 'Description', with: Faker::Hipster.sentence
      click_on 'Create API Key'
    end

    api_key = ApiKey.last

    expect(page).to have_current_path("/account/api_keys/#{api_key.id}")
      .and have_field('API Secret', with: api_key.token)
  end

  it 'hides the API secret when viewing an existing API key' do
    sign_in_to_pone(owner)
    api_key = create(:api_key, pone: owner)

    visit "/account/api_keys/#{api_key.id}"

    expect(page).to have_content(api_key.name)
      .and have_field('API Secret', with: '*' * 80)
  end

  it 'allows the pone to generate a new secret to an API key' do
    sign_in_to_pone(owner)
    api_key = create(:api_key, pone: owner)

    visit "/account/api_keys/#{api_key.id}"

    expect do
      click_on 'Regenerate Secret'
    end.to change { api_key.reload.token }

    expect(page).to have_current_path("/account/api_keys/#{api_key.id}")
      .and have_field('API Secret', with: api_key.reload.token)
  end

  it 'allows the pone to revoke their API key' do
    sign_in_to_pone(owner)
    api_key = create(:api_key, pone: owner)

    visit "/account/api_keys/#{api_key.id}"

    expect do
      click_on 'Revoke API Key'
    end.to change { api_key.reload.revoked? }.to(true)

    expect(page).to have_current_path("/account/api_keys/#{api_key.id}")
      .and have_content("Revoked on #{I18n.l(api_key.revoked_at)}")
  end
end
