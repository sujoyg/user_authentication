require 'spec_helper'

describe 'accounts/default_signup', :type => :view do
  it 'should render a signup form' do
    render
    expect(rendered).to have_rendered(partial: 'shared/_signup')
  end
end
