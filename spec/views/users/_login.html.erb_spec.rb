require 'spec_helper'

describe 'users/_login' do
  it 'should have a login form' do
    render
    rendered.should have_selector('form', :action => login_path, :method => 'post') do |form|
      form.should have_selector('input', :type => 'text', :name => 'email')
      form.should have_selector('label', :for => 'email', :content => 'Email')

      form.should have_selector('input', :type => 'password', :name => 'password')
      form.should have_selector('label', :for => 'password', :content => 'Password')

      form.should have_selector('input', :type => 'submit', :value => 'Log In')
    end
  end
end