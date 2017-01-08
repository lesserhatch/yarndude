class BlanketsController < ApplicationController
  def index
  end

  def new
    @blanket = Blanket.new
  end

  def create
    @blanket = Blanket.new(blanket_params)

    if @blanket.save
      redirect_to @blanket
    else
      render :new
    end
  end

  def show
    @blanket = Blanket.find(params[:id])
  end

  private

  def blanket_params
    params.require(:blanket).permit(
      :name,
      :email,
      :start_date,
      :end_date,
      :address,
      :custom_coordinates,
      :latitude,
      :longitude,
      :utc_offset)
  end

end
