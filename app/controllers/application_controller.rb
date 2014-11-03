class ApplicationController < ActionController::Base
  before_filter :set_current_user

  # private

  # redirect: Path to login page.
  def authorize(redirect=nil)
    # Not using skip_before_filter, since main app could inadvertently override that
    # by using a before_filter :authorize in its application_controller.
    if params[:controller] == 'users' && ['do_login', 'login', 'logout', 'do_signup', 'signup'].include?(params[:action])
      return true
    end

    if current_user.nil?
      session[:redirect] = url_for params
      redirect_to redirect || login_path, alert: 'Please log in to access this page.'
    else
      return true
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

  def redirect
    session_redirect = session.delete(:redirect)
    redirect_to params[:redirect] || session_redirect || root_path
  end
end

require File.join Rails.root, 'app/controllers/application_controller'