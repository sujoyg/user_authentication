Dummy::Application.routes.draw do
  UserAuthentication::Engine.routes

  # Sample route for testing
  resources :sales do
    get 'recent', :on => :collection
  end

  root :to => 'welcome#index'
  end
