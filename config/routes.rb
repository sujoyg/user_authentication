Rails.application.routes.draw do
  match "login" => "accounts#login", :via => :get
  match "login" => "accounts#do_login", :via => :post

  match "logout" => "accounts#do_logout", :via => :get

  match "signup" => "accounts#signup", :via => :get
  match "signup" => "accounts#do_signup", :via => :post

  match "set_password" => "accounts#set_password", :via => :post
end