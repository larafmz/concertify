Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  devise_for :users

  get "/searchs", to: "searchs#index"

  resources :artists
  resources :registered_concerts
  resources :future_assistances

  resources :concerts do
    collection do
      get :pending
    end
  end


end