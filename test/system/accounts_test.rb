require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  test "creating valid new user account" do
    visit root_url

    assert_selector "h2", text: "Log in"

    click_on 'Sign up'

    assert_selector "h2", text: "Sign up"

    fill_in 'Email', with: 'c@c.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_on 'Sign up'

    assert_text 'Complete profile'
  end

  test "creating invalid new user account due to existing email" do
    visit root_url

    assert_selector "h2", text: "Log in"

    click_on 'Sign up'

    assert_selector "h2", text: "Sign up"

    fill_in 'Email', with: 'a@a.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_on 'Sign up'

    assert_text 'Email has already been taken'
  end
end
