Rails.application.routes.draw do
  match "login" => "users#login", :via => :get
  match "login" => "users#do_login", :via => :post

  match "logout" => "users#do_logout", :via => :get

  match "signup" => "users#signup", :via => :get
  match "signup" => "users#do_signup", :via => :post

  match "set_password" => "users#set_password", :via => :post
end