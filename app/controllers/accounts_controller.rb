class AccountsController < ApplicationController
  before_filter :authorize, only: [:do_set_password]

  def login
  end


  def do_login
    account = Account.find_by_email params[:email]
    if account && account.authenticate(params[:password])
      session[:account_id] = account.id
      set_current_account

      if respond_to? :on_login
        on_login
      else
        redirect
      end
    else
      redirect_to :back, alert: 'Please check email and password.'
    end
  end


  def logout
    session.delete :account_id
    set_current_account

    if respond_to? :on_logout
      on_logout
    else
      redirect_to params[:redirect] || root_path
    end
  end


  def signup
  end


  def do_signup
    account = Account.new
    account.email = params[:email]
    account.password = params[:password]
    (account.attributes.keys - ['email', 'password_digest']).each do |attr|
      account.send "#{attr}=", params[attr.to_sym]
    end

    if account.save
      session[:account_id] = account.id
      set_current_account

      if respond_to? :on_signup
        on_signup
      else
        redirect
      end
    else
      redirect_to :back, alert: "Please check email and password."
    end
  end


  def do_set_password
    unless params[:password] == params[:password_confirmation]
      return redirect_to :back, alert: 'Passwords do not match.'
    end

    current_account.password = params[:password]
    current_account.save

    if respond_to? :on_set_password
      on_set_password
    else
      redirect
    end
  end
end

controller = File.join Rails.root, 'app/controllers/accounts_controller.rb'
require controller if File.exists? controller
