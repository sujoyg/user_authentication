class UsersController < ApplicationController
  before_filter :authorize, only: [:set_password]

  def login
  end

  def signup
  end

  def do_login
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      set_current_user

      if respond_to? :on_login
        on_login
      else
        redirect
      end
    else
      redirect_to :back, alert: "Please check email and password."
    end
  end

  def do_logout
    session.delete :user_id
    set_current_user

    if respond_to? :on_logout
      on_logout
    else
      redirect_to :back
    end
  end

  def do_signup
    user = User.new
    user.email = params[:email]
    user.password = params[:password]

    if user.save
      session[:user_id] = user.id
      set_current_user

      if respond_to? :on_signup
        on_signup
      else
        redirect
      end
    else
      redirect_to :back, alert: "Please check email and password."
    end
  end

  def set_password
    current_user.password = params[:password]
    current_user.save

    if respond_to? :on_set_password
      on_set_password
    else
      redirect
    end
  end
end

controller = File.join Rails.root, 'app/controllers/users_controller.rb'
require controller if File.exists? controller
