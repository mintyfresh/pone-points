# frozen_string_literal: true

RSpec.describe 'SignIn', type: :feature do
  let(:pone) { Pone.find_by(name: input[:name]) }
  let(:input) { build(:sign_in_input) }

  # @param input [Hash]
  # @return [void]
  def fill_in_sign_in_form(input)
    within('#sign_in_form') do
      fill_in('Name', with: input[:name])
      fill_in('Password', with: input[:password])
      click_button('Sign In')
    end
  end

  it 'signs the pone in' do
    visit sign_in_path
    fill_in_sign_in_form input

    expect(page).to have_current_path(pone_path(pone, mode: 'points'))
  end

  it 'redirects the pone based on their return path' do
    visit sign_in_path(return_path: account_integrations_path)
    fill_in_sign_in_form input

    expect(page).to have_current_path(account_integrations_path)
  end

  it 'preserves the return path when switching to sign up' do
    visit sign_in_path(return_path: account_integrations_path)

    within('#sign_in_form') do
      click_link 'Sign Up'
    end

    expect(page).to have_current_path(sign_up_path(return_path: account_integrations_path))
  end

  it 'redirects already signed in pones to home' do
    sign_in_to_pone(create(:pone))
    visit sign_in_path

    expect(page).to have_current_path(root_path)
  end

  context 'when the credentials are invalid' do
    let(:input) { build(:sign_in_input, :incorrect_password) }

    it 'displays an error message to the pone' do
      visit sign_in_path
      fill_in_sign_in_form input

      expect(page).to have_current_path(sign_in_path)
        .and have_content('Name or password is incorrect')
    end
  end
end
