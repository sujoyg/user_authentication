Rails.application.routes.draw do
  get 'login' => 'accounts#login'
  post 'login' => 'accounts#do_login'
  get 'logout' => 'accounts#logout'
  post 'set_password' => 'accounts#do_set_password'
  get 'signup' => 'accounts#signup'
  post 'signup' => 'accounts#do_signup'
end