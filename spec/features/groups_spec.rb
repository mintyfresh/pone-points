# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :feature do
  let(:group) { create(:group) }
  let(:pone) { create(:pone, :verified) }

  it 'allows pones to view existing groups' do
    sign_in_to_pone(pone)
    groups = create_list(:group, 5)

    visit '/groups'

    groups.each do |group|
      expect(page).to have_link(group.name, href: "/groups/#{group.slug}")
    end
  end

  it 'allows pones to join groups' do
    sign_in_to_pone(pone)

    visit "/groups/#{group.slug}"

    click_on 'Join Group'

    expect(page).to have_current_path("/groups/#{group.slug}")
      .and have_button('Controls')
  end

  it "allows pones to leave groups they've joined" do
    sign_in_to_pone(pone)
    group.add_member(pone)

    visit "/groups/#{group.slug}"

    click_on 'Controls'
    click_on 'Leave Group'

    expect(page).to have_current_path("/groups/#{group.slug}")
      .and have_button('Join Group')
  end

  it "allows pones to configure webhooks for groups they've joined" do
    sign_in_to_pone(pone)
    group.add_member(pone)

    visit "/groups/#{group.slug}"

    within '#group_controls_dropdown' do
      click_on 'Controls'
      click_on 'Webhooks'
    end

    expect(page).to have_current_path("/groups/#{group.slug}/webhooks")
  end

  it "doesn't allow group owners to leave their own groups" do
    sign_in_to_pone(group.owner)

    visit "/groups/#{group.slug}"

    click_on 'Controls'
    click_on 'Leave Group'

    expect(page).to have_current_path("/groups/#{group.slug}")
      .and have_button('Controls')
  end

  it 'allows pones to create new groups' do
    sign_in_to_pone(pone)

    visit '/groups'
    click_on 'Create New Group'

    within '#new_group_form' do
      fill_in 'Name', with: 'Test Group'
      fill_in 'Description', with: Faker::Hipster.sentence
      click_on 'Create Group'
    end

    expect(page).to have_current_path('/groups/test-group')
      .and have_content('Test Group')
  end

  it 'shows an error message if input is invalid while creating a group' do
    sign_in_to_pone(pone)

    visit '/groups'
    click_on 'Create New Group'

    within '#new_group_form' do
      fill_in 'Name', with: ''
      click_on 'Create Group'
    end

    expect(page).to have_current_path('/groups')
      .and have_content('Create New Group')
      .and have_content("can't be blank")
  end

  it 'redirects guests away if they try to create a new group' do
    visit '/groups'
    expect(page).not_to have_button('Create New Group')

    visit '/groups/new'
    expect(page).to have_current_path(sign_in_path(return_path: '/groups/new'))
  end

  it 'allows the owner to edit their groups' do
    sign_in_to_pone(group.owner)
    visit "/groups/#{group.slug}"

    click_on 'Controls'
    click_on 'Edit Group'

    within '#edit_group_form' do
      fill_in 'Description', with: 'A new description'
      click_on 'Save Changes'
    end

    expect(page).to have_current_path("/groups/#{group.slug}")
      .and have_content('A new description')
  end

  it "doesn't allow pones to edit groups they don't own" do
    group.add_member(pone)
    sign_in_to_pone(pone)
    visit "/groups/#{group.slug}"

    click_on 'Controls'
    expect(page).not_to have_button('Edit Group')

    visit "/groups/#{group.slug}/edit"
    expect(page).to have_current_path('/404.html')
  end

  it 'allows the owner to upload an image for their groups' do
    sign_in_to_pone(group.owner)
    visit "/groups/#{group.slug}"

    expect(page).not_to have_css("#group_#{group.slug}_image")

    click_on 'Controls'
    click_on 'Upload Image'

    within '#edit_group_image_form' do
      attach_file 'Group Image', Rails.root.join('spec', 'support', 'avatar.png')
      click_on 'Upload Image'
    end

    expect(page).to have_current_path("/groups/#{group.slug}")
      .and have_css("#group_#{group.slug}_image")
  end
end
