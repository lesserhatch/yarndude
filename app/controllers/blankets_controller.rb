class BlanketsController < ApplicationController
  PRICE_IN_CENTS = 300

  def index
    redirect_to action: 'new'
  end

  def new
    @blanket = Blanket.new
  end

  def create
    @blanket = Blanket.new(blanket_params)

    if @blanket.save
      BlanketFetchDataJob.perform_later(@blanket, 10)
      redirect_to blanket_path(slug: @blanket.slug)
      session[:email] = @blanket.email
    else
      render :new
    end
  end

  def show
    @blanket = Blanket.find_by_slug(params[:slug])
    @palette = Palette.first
    @price_in_cents = PRICE_IN_CENTS

    @units = params[:units].present? ? params[:units].to_sym : :farhenheit
    @units = :farhenheit unless [:farhenheit, :celsius].include? @units
    @units_display = (@units == :farhenheit) ? 'F' : 'C'

    respond_to do |format|
      format.html
      format.svg
    end
  end

  def pay
    @blanket = Blanket.find_by_slug(params[:slug])

    if not @blanket.paid?
      # Amount in cents
      amount = PRICE_IN_CENTS

      if @blanket.customer_id.nil?
        customer = Stripe::Customer.create(
            :email  => @blanket.email,
            :source => params[:stripeToken]
        )

        @blanket.customer_id = customer.id
        @blanket.save
      end

      charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => amount,
          :description => @blanket.name,
          :currency    => 'usd',
          :metadata    => {"blanket_slug" => @blanket.slug}
      )

      @blanket.charge_id = charge.id
      @blanket.save

      UserMailer.receipt_email(@blanket).deliver_later
      BlanketFetchDataJob.perform_later @blanket
    end

    redirect_to action: 'show', slug: @blanket.slug

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to blanket_path(slug: @blanket.slug)
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
      :utc_offset,
      :private)
  end

end
