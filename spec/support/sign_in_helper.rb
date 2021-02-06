# frozen_string_literal: true

module SignInHelper
  # @param name [String]
  # @param password [String]
  def sign_in(name, password)
    visit(sign_in_path)
    within('#sign_in_form') do
      fill_in('Name', with: name)
      fill_in('Password', with: password)
      click_button('Sign In')
    end
  end

  # @param pone [Pone]
  # @return [void]
  def sign_in_to_pone(pone)
    password = Faker::Internet.password

    pone.credential(PonePasswordCredential, build_if_missing: true)
      .update!(password: password)

    sign_in(pone.name, password)
  end
end
