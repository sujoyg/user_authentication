require 'spec_helper'

describe 'shared/_signup', :type => :view do
  it 'should have a signup form' do
    render

    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] input[type='text'][name='email']")
    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] label[for='email']", text: 'Your email')

    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] input[type='text'][name='email_confirmation']")
    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] label[for='email_confirmation']", text: 'Confirm your email')

    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] input[type='password'][name='password']")
    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] label[for='password']", text: 'Choose a password')

    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] input[type='submit'][value='Sign Up']")
  end

  it 'should render a hidden redirect field if specified' do
    redirect_url = random_url

    render partial: 'shared/signup', locals: {redirect: redirect_url}
    expect(rendered).to have_selector("form[action='#{signup_path}'][method='post'] input[type='hidden'][name='redirect'][value='#{redirect_url}']")
  end

  it 'should not render a hidden redirect field if not specified' do
    render partial: 'shared/signup'
    expect(rendered).to_not have_selector("form[action='#{signup_path}'][method='post'] input[type='hidden'][name='redirect']")
  end
end