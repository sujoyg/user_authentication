require 'spec_helper'

describe 'routes' do
  it 'routes GET /login' do
    login_path.should == '/login'
    {post: '/login'}.should route_to controller: 'users', action: 'login'
  end

  it 'routes GET /logout' do
    logout_path.should == '/logout'
    {get: '/logout'}.should route_to controller: 'users', action: 'logout'
  end

  it 'routes POST /users' do
    users_path.should == '/users'
    {post: '/users'}.should route_to controller: 'users', action: 'create'
  end
end