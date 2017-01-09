class Admin::BlanketsController < AdminController
  def index
    @blankets = Blanket.all.page(params[:page])
  end

  def show
    @blanket = Blanket.find(params[:id])
  end

  def edit
    @blanket = Blanket.find(params[:id])
  end
end
