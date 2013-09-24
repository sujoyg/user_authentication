Rails.application.routes.draw do
  match 'login' => 'users#login', :via => :post
  match 'logout' => 'users#logout', :via => :get
  match 'signup' => 'users#signup', :via => :post
end