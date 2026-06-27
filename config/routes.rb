Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  get "/searchs", to: "searchs#index"

  devise_for :users
  resources :users
  resources :registered_concerts
  resources :future_assistances

  resources :artists do
    member do
      post :follow
      delete :unfollow
    end
  end

  resources :concerts do
    collection do
      get :requested
    end
  end


end