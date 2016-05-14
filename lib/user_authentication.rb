module UserAuthentication
  class Engine < Rails::Engine
    engine_name 'user_authentication'

    initializer 'user_authentication_engine.app_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        require File.expand_path('../../app/controllers/application_controller', __FILE__)
        require File.expand_path('../../app/helpers/application_helper', __FILE__)
      end
    end

    config.after_initialize do
      require File.expand_path('../../app/models/account', __FILE__)
    end

    def self.routes
      Rails.application.routes.draw do
        get 'login' => 'accounts#login'
        post 'login' => 'accounts#do_login'
        get 'logout' => 'accounts#logout'
        post 'set_password' => 'accounts#do_set_password'
        get 'signup' => 'accounts#signup'
        post 'signup' => 'accounts#do_signup'
      end
    end
  end
end
