class Admin::LoginsController < AdminController
  skip_before_action :require_login, only: [:new, :create]
  layout 'admin_login'

  def new
    redirect_to admin_blankets_path if logged_in?
    @manager = Manager.new
  end

  def create
    @manager = Manager.find_by_email(params[:email])

    if @manager.try(:authenticate, params[:password])
      session[:manager] = @manager.id
      redirect_to admin_blankets_path
    else
      @manager ||= Manager.new(:email => params[:email])
      render 'new'
    end
  end

  def destroy
    session[:manager] = nil
    redirect_to root_path
  end
end
