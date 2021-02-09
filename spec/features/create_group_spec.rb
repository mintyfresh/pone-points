# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateGroup', type: :feature do
  let(:input) { build(:create_group_input) }
  let(:owner) { create(:pone, :verified) }

  # @param input [Hash]
  # @return [void]
  def fill_in_create_group_form(input)
    within('#create_group_form') do
      fill_in('Name', with: input[:name])
      fill_in('Description', with: input[:description])
      click_button('Create Group')
    end
  end

  it 'creates a new group' do
    sign_in_to_pone(owner)

    visit(new_group_path)
    fill_in_create_group_form(input)

    expect(page).to have_current_path(group_path(input[:name].parameterize))
      .and have_content(input[:name])
  end

  it 'redirects to the sign in page if not logged in' do
    visit(new_group_path)

    expect(page).to have_current_path(sign_in_path(return_path: new_group_path))
  end

  it 'displays an error message when the input is invalid' do
    sign_in_to_pone(owner)

    visit(new_group_path)
    fill_in_create_group_form(**input, name: '')

    expect(page).to have_current_path(groups_path)
      .and have_content("can't be blank")
  end
end
