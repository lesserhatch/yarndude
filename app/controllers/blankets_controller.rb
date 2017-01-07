class BlanketsController < ApplicationController
  def index
  end

  def new
    @blanket = Blanket.new
  end

  def create
    @blanket = Blanket.new(blanket_params)
    @blanket.save

    redirect_to @blanket
  end

  def show
    @blanket = Blanket.find(params[:id])
  end

  private

  def blanket_params
    params.require(:blanket).permit(:name, :start_date, :end_date, :latitude, :longitude)
  end

end
