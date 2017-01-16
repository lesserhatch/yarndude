class IndexController < ApplicationController
  def index
    @sample_blankets = Blanket.where(example: true)
  end
end
