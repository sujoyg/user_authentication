class UsersController < ApplicationController
  def login
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session.delete(:return_to) || root_path
    else
      redirect_to root_path, alert: "Please check email and password."
    end
  end

  def logout
    session.delete :return_to
    session.delete :user_id

    redirect_to root_path
  end

  def signup
    user = User.new
    user.email = params[:email]
    user.password = params[:password]

    if user.save
      render json: {email: user.email}, status: :ok
    else
      render json: {errors: user.errors}, status: :bad_request
    end
  end
end
