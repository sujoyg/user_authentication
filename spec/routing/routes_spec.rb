require 'spec_helper'

describe 'routes', :type => :routing do
  it 'routes POST /login' do
    expect(login_path).to eq '/login'
    expect({get: '/login'}).to route_to controller: 'accounts', action: 'login'
    expect({post: '/login'}).to route_to controller: 'accounts', action: 'do_login'
  end

  it 'routes GET /logout' do
    expect(logout_path).to eq '/logout'
    expect({get: '/logout'}).to route_to controller: 'accounts', action: 'do_logout'
  end

  it 'routes POST /signup' do
    expect(signup_path).to eq '/signup'
    expect({post: '/signup'}).to route_to controller: 'accounts', action: 'do_signup'
  end
end