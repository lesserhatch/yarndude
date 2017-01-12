class Admin::YarnsController < AdminController
  def index
    @yarns = Yarn.all.order(name: :asc).page(params[:page])
  end

  def show
    @yarn = Yarn.find(params[:id])
  end

  def edit
  end

  def new
  end
end
