class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end
  def show
    @category = Category.find(params[:id])
    @restaurants = @category.restaurants.order(:name).page(params[:page]).per(20)
  end
end