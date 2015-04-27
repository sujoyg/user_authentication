class ApplicationController < ActionController::Base
  before_filter :set_current_account

  # private

  # redirect: Path to login page.
  def authorize(redirect=nil)
    # Not using skip_before_filter, since main app could inadvertently override that
    # by using a before_filter :authorize in its application_controller.
    if params[:controller] == 'accounts' && ['do_login', 'login', 'do_logout', 'do_signup', 'signup'].include?(params[:action])
      return true
    end

    if current_account.nil?
      session[:redirect] = url_for params
      redirect_to redirect || login_path, alert: 'Please log in to access this page.'
    else
      return true
    end
  end

  def current_account
    @current_account
  end

  def set_current_account
    if session[:account_id].nil?
      @current_account = nil
    elsif @current_account.nil? || @current_account.id != session[:account_id]
      @current_account = Account.find session[:account_id]
    end

    true
  end

  def redirect
    session_redirect = session.delete(:redirect)
    redirect_to params[:redirect] || session_redirect || root_path
  end
end

require File.join Rails.root, 'app/controllers/application_controller'