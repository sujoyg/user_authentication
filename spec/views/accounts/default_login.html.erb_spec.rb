require 'spec_helper'

describe 'accounts/default_login', :type => :view do
  it 'should have a login form' do
    render
    expect(rendered).to have_rendered(partial: 'shared/_login')
  end
end
