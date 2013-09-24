Rails.application.routes.draw do
  match "login" => "users#login", :via => :post
  match "logout" => "users#logout", :via => :get
  resources :users, only: [:create]
end