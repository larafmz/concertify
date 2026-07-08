Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  get "/searchs", to: "searchs#index"
  get "change_locale/:locale", to: "application#change_locale", as: :change_locale
  
  devise_for :users
  resources :users
  resources :registered_concerts
  resources :future_assistances

  resources :artists do
    member do
      post :follow
      delete :unfollow
    end
    collection do
      get :requested
    end    
  end

  resources :concerts do
    collection do
      get :requested
    end
  end

  


end