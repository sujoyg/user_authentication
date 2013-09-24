require 'spec_helper'

describe 'routes' do
  it 'routes POST /login' do
    login_path.should == '/login'
    {post: '/login'}.should route_to controller: 'users', action: 'login'
  end

  it 'routes GET /logout' do
    logout_path.should == '/logout'
    {get: '/logout'}.should route_to controller: 'users', action: 'logout'
  end

  it 'routes POST /signup' do
    signup_path.should == '/signup'
    {post: '/signup'}.should route_to controller: 'users', action: 'signup'
  end
end