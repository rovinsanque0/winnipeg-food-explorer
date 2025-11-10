# config/routes.rb
Rails.application.routes.draw do
  root "home#index"
  get :about, to: "home#about"

  resources :wards, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :restaurants, only: %i[index show] do
    resources :reviews, only: %i[new create]
  end
end
