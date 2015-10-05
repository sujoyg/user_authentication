require 'spec_helper'

RSpec.describe AccountsController, type: :routing do
  describe 'routing' do
    it 'routes to #login' do
      expect(get: '/login').to route_to 'accounts#login'
    end

    it 'routes to #do_login' do
      expect(post: '/login').to route_to 'accounts#do_login'
    end

    it 'routes to #logout' do
      expect(get: '/logout').to route_to 'accounts#logout'
    end

    it 'routes to #do_set_password' do
      expect(post: '/set_password').to route_to 'accounts#do_set_password'
    end

    it 'routes to #signup' do
      expect(get: '/signup').to route_to 'accounts#signup'
    end

    it 'routes to #do_signup' do
      expect(post: '/signup').to route_to 'accounts#do_signup'
    end
  end

  describe 'route helpers' do
    it { expect(login_path).to eq '/login' }
    it { expect(logout_path).to eq '/logout' }
    it { expect(signup_path).to eq '/signup' }
  end
end
