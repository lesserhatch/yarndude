class IndexController < ApplicationController
  def index
    @sample_blankets = Blanket.where(example: true)
    @recent_blankets = Blanket.where(private: false).order(created_at: :desc).limit(10)
  end
end
