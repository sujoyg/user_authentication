require 'spec_helper'

describe 'shared/_login', :type => :view do
  it 'should have a login form' do
    render

    expect(rendered).to have_selector("form[action='#{login_path}'][method='post'] input[type='text'][name='email']")
    expect(rendered).to have_selector("form[action='#{login_path}'][method='post'] label[for='email']", text: 'Email')

    expect(rendered).to have_selector("form[action='#{login_path}'][method='post'] input[type='password'][name='password']")
    expect(rendered).to have_selector("form[action='#{login_path}'][method='post'] label[for='password']", text: 'Password')

    expect(rendered).to have_selector("form[action='#{login_path}'][method='post'] input[type='submit'][value='Log In']")
  end

  it 'should render a hidden redirect field if specified' do
    redirect_url = random_url

    render partial: 'shared/login', locals: {redirect: redirect_url}
    expect(rendered).to have_selector("form[action='#{login_path}'][method='post'] input[type='hidden'][name='redirect'][value='#{redirect_url}']")
  end

  it 'should not render a hidden redirect field if not specified' do
    render partial: 'shared/login'
    expect(rendered).to_not have_selector("form[action='#{login_path}'][method='post'] input[type='hidden'][name='redirect']")
  end
end