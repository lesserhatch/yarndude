class Admin::YarnsController < AdminController
  def create
    @yarn = Yarn.new(yarn_params)
    if @yarn.save
      redirect_to [:admin, @yarn]
    else
      render :new
    end
  end

  def destroy
    @yarn = Yarn.find(params[:id])
    @yarn.try(:destroy)
    redirect_to admin_yarns_path
  end

  def edit
    @yarn = Yarn.find(params[:id])
    @yarn
  end

  def index
    @yarns = Yarn.all.order(name: :asc).page(params[:page])
  end

  def new
    @yarn = Yarn.new
  end

  def show
    @yarn = Yarn.find(params[:id])
  end

  def update
    @yarn = Yarn.find(params[:id])
    if @yarn.update_attributes(yarn_params)
      redirect_to [:admin, @yarn]
    else
      render :edit
    end
  end

  private

  def yarn_params
    params.require(:yarn).permit(:name, :short_name, :color)
  end
end
