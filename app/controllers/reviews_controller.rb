class ReviewsController < ApplicationController
  before_action :set_restaurant

  def new
    @review = @restaurant.reviews.new
  end

  def create
    @review = @restaurant.reviews.new(review_params)
    if @review.save
      redirect_to @restaurant, notice: "Review added!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :author)
  end
end
