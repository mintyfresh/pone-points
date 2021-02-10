# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GivePoints', type: :feature do
  let(:pone) { create(:pone) }
  let(:granted_by) { create(:pone, :verified) }
  let(:input) { build(:create_point_input) }

  # @param input [Hash]
  # @return [void]
  def fill_in_create_point_form(input)
    within('#create_point_form') do
      select(input[:count], from: 'Count')
      fill_in('Message', with: input[:message])
      click_button('Give Points!')
    end
  end

  it 'gives the pone some points' do
    sign_in_to_pone(granted_by)

    visit give_pone_points_path(pone)
    fill_in_create_point_form(input)

    expect(page).to have_current_path(pone_path(pone, mode: 'points'))
      .and have_content("#{granted_by.name} gave #{pone.name} #{input[:count]}" \
        " good pone #{'point'.pluralize(input[:count])}!")
      .and have_content(input[:message])
  end

  it 'redirects to the sign in page if not logged in' do
    visit give_pone_points_path(pone)

    expect(page).to have_current_path(sign_in_path(return_path: give_pone_points_path(pone)))
  end

  context 'when the input is invalid' do
    let(:input) { build(:create_point_input, message: '') }

    it 'displays an error message' do
      sign_in_to_pone(granted_by)

      visit give_pone_points_path(pone)
      fill_in_create_point_form(input)

      expect(page).to have_current_path(pone_points_path(pone))
        .and have_content("can't be blank")
    end
  end
end
