class HomeController < ApplicationController
  def index
    @recent = Restaurant.order(created_at: :desc).limit(6)
  end
  def about; end
end