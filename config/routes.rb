Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  devise_for :users

  get "/searchs", to: "searchs#index"

  resources :artists
  resources :concerts
  resources :registered_concerts
  resources :future_assistances



end