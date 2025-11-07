class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant
      .search(params[:q])
      .by_ward(params[:ward_id])
      .by_category(params[:category_id])
      .order(:name)
      .page(params[:page]).per(20)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @inspections = @restaurant.inspections.order(inspected_on: :desc).page(params[:page]).per(10)
    @reviews = @restaurant.reviews.order(created_at: :desc).limit(10)
  end
end