class AdminController < ApplicationController
  before_action :require_login
  layout 'admin'
  helper_method :logged_in?

  private

  def require_login
    unless logged_in?
      redirect_to admin_login_path
    end
  end

  def current_manager
    @current_manager ||= Manager.find_by_id(session[:manager])
  end

  def logged_in?
    current_manager != nil
  end

end
