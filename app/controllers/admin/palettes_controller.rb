class Admin::PalettesController < AdminController
  def index
    @palettes = Palette.all.page(params[:page])
  end

  def show
    @palette = Palette.find(params[:id])
  end
end
