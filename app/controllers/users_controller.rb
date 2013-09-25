controller = File.join Rails.root, 'app/controllers/users_controller.rb'
require controller if File.exists? controller

class UsersController < ApplicationController
  def login
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      set_current_user

      if respond_to? :on_login
        on_login
      else
        redirect_to :back
      end
    else
      redirect_to :back, alert: 'Please check email and password.'
    end
  end

  def logout
    session.delete :user_id
    set_current_user

    if respond_to? :on_logout
      on_logout
    else
      redirect_to :back
    end
  end

  def signup
    user = User.new
    user.email = params[:email]
    user.password = params[:password]

    if user.save
      session[:user_id] = user.id
      set_current_user

      if respond_to? :on_signup
        on_signup
      else
        redirect_to :back
      end
    else
      redirect_to :back, alert: 'Please check email and password.'
    end
  end
end
