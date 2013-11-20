class ApplicationController < ActionController::Base
  before_filter :set_current_user

 # private

  def authorize
    # Not using skip_before_filter, since main app could inadvertently override that, for example,
    # by using a before_filter in its application_controller.
    if params[:controller] == 'users' && ['login', 'logout', 'signup'].include?(params[:action])
      return true
    end

    if current_user.nil?
      session[:return_to] = url_for params
      redirect_to root_path, alert: "Please log in to access this page."
    end
  end

  def current_user
    @current_user
  end

  def set_current_user
    if session[:user_id].nil?
      @current_user = nil
    elsif @current_user.nil? || @current_user.id != session[:user_id]
      @current_user = User.find session[:user_id]
    end

    true
  end
end

require File.join Rails.root, 'app/controllers/application_controller'