class BlanketsController < ApplicationController
  def index
    redirect_to action: 'new'
  end

  def new
    @blanket = Blanket.new
  end

  def create
    @blanket = Blanket.new(blanket_params)

    if @blanket.save
      BlanketFetchDataJob.perform_later @blanket
      redirect_to action: 'show', slug: @blanket.slug
    else
      render :new
    end
  end

  def show
    @blanket = Blanket.find_by_slug(params[:slug])
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
