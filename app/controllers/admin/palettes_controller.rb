class Admin::PalettesController < AdminController
  def create
    @palette = Palette.new(palette_params)
    if @palette.save
      redirect_to [:admin, @palette]
    else
      render :new
    end
  end

  def destroy
    @palette = Palette.find(params[:id])
    @palette.try(:destroy)
    redirect_to admin_palettes_path
  end

  def edit
    @palette = Palette.find(params[:id])
  end

  def index
    @palettes = Palette.all.page(params[:page])
  end

  def new
    @palette = Palette.new
  end

  def show
    @palette = Palette.find(params[:id])
  end

  def update
    @palette = Palette.find(params[:id])
    if @palette.update_attributes(palette_params)
      redirect_to [:admin, @palette]
    else
      render :edit
    end
  end

  private

  def palette_params
    params.require(:palette).permit(:name, temperature_ranges_attributes: [:id, :yarn_id, :low_temperature, :high_temperature, :_destroy])
  end
end
