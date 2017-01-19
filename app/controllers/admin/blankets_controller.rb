class Admin::BlanketsController < AdminController
  def index
    @blankets = Blanket.order(created_at: :desc).page(params[:page])
  end

  def show
    @blanket = Blanket.find(params[:id])
    @charge  = nil
    @charge  = Stripe::Charge.retrieve(@blanket.charge_id) if @blanket.charge_id.present?
  end

  def edit
    @blanket = Blanket.find(params[:id])
  end

  def destroy
    @blanket = Blanket.find(params[:id])
    @blanket.try(:destroy)
    redirect_to admin_blankets_path
  end

  def restart_job
    @blanket = Blanket.find(params[:id])
    BlanketFetchDataJob.perform_later @blanket
    redirect_to admin_blanket_path @blanket
  end

  def refund
    @blanket = Blanket.find(params[:id])
    @refund =  Stripe::Refund.create(charge: @blanket.charge_id)
    redirect_to admin_blanket_path @blanket
  rescue
    redirect_to admin_blanket_path @blanket
  end

  def toggle_example
    @blanket = Blanket.find(params[:id])
    @blanket.example = !@blanket.example
    @blanket.save
    redirect_to admin_blanket_path @blanket
  end
end
