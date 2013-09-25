class ApplicationController < ActionController::Base
  before_filter :set_current_user

 # private

  def authorize
    # Not using skip before_filter, since main app could inadvertantly override that.
    # For example, it could have required the filter in its application_controller.
    return true if params[:controller] == 'users' && params[:action] == 'login'

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