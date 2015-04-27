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
  end
end