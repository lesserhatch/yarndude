class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :free_mode?

  def free_mode?
    Rails.application.config.free_mode || false
  end
end
