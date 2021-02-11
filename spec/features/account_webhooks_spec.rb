# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccountWebhooks', type: :feature do
  let(:owner) { create(:pone, :verified) }

  it 'allows the pone to view webhooks on their account' do
    sign_in_to_pone(owner)
    webhooks = create_list(:pone_webhook, 5, owner: owner, event_source: owner)

    visit '/account/webhooks'

    webhooks.each do |webhook|
      expect(page).to have_link(webhook.name, href: "/account/webhooks/#{webhook.id}")
    end
  end

  it 'allows the pone to create an webhook' do
    sign_in_to_pone(owner)

    visit '/account/webhooks'
    click_on 'Create Webhook'

    expect(page).to have_current_path('/account/webhooks/new')

    within '#new_webhook_form' do
      fill_in 'Name', with: 'Test Webhook'
      fill_in 'URL', with: Faker::Internet.url
      check 'Point Given'
      click_on 'Create Webhook'
    end

    webhook = PoneWebhook.last

    expect(page).to have_current_path("/account/webhooks/#{webhook.id}")
      .and have_field('Signing Key', with: webhook.signing_key)
  end

  it 'shows an error message when unable to create an webhook' do
    sign_in_to_pone(owner)

    visit '/account/webhooks'
    click_on 'Create Webhook'

    expect(page).to have_current_path('/account/webhooks/new')

    within '#new_webhook_form' do
      fill_in 'Name', with: ''
      click_on 'Create Webhook'
    end

    expect(page).to have_current_path('/account/webhooks')
      .and have_content("can't be blank")
  end

  it 'hides the signing key when viewing an existing webhook' do
    sign_in_to_pone(owner)
    webhook = create(:pone_webhook, owner: owner, event_source: owner)

    visit "/account/webhooks/#{webhook.id}"

    expect(page).to have_content(webhook.name)
      .and have_field('Signing Key', with: '*' * 80)
  end

  it 'allows the pone to generate a new secret to an webhook' do
    sign_in_to_pone(owner)
    webhook = create(:pone_webhook, owner: owner, event_source: owner)

    visit "/account/webhooks/#{webhook.id}"

    expect do
      click_on 'Regenerate Signing Key'
    end.to change { webhook.reload.signing_key }

    expect(page).to have_current_path("/account/webhooks/#{webhook.id}")
      .and have_field('Signing Key', with: webhook.reload.signing_key)
  end

  it 'allows the pone to delete their webhook' do
    sign_in_to_pone(owner)
    webhook = create(:pone_webhook, owner: owner, event_source: owner)

    visit "/account/webhooks/#{webhook.id}"

    expect do
      click_on 'Delete Webhook'
    end.to change { owner.webhooks.count }.by(-1)

    expect(page).to have_current_path('/account/webhooks')
  end
end
