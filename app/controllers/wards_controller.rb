class WardsController < ApplicationController
  def index
    @wards = Ward.order(:name)
  end
  def show
    @ward = Ward.find(params[:id])
    @restaurants = @ward.restaurants.order(:name).page(params[:page]).per(20)
  end
end