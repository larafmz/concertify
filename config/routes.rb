Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  get "/searchs", to: "searchs#index"
  get "change_locale/:locale", to: "application#change_locale", as: :change_locale
  
  devise_for :users

  resources :users do
    member do
      post :follow
      delete :unfollow
      post :block
      delete :unblock
      get :followers
      get :followings
      get :registers
      get :diary
      get :future_assistances
      get :publications
      get :artists
      get :requests
    end
  end
  
  resources :registers 

  resources :interactuables do
    member do
      post :like
      post :repost
      post :comment
      delete :uncomment
      get :reposts
      get :comments
    end
  end

  resources :future_assistances
  resources :likes
  resources :publications

  resources :artists do
    member do
      post :post
      post :follow
      delete :unfollow
      post :mark_as_favorite
      delete :unmark_as_favorite
      get :followers
      get :publications
      get :registers
    end
    collection do
      get :requested
    end    
  end

  resources :concerts do
    collection do
      get :requested
    end
    member do
      post :post
      get :registers
      get :future_assistances
      get :publications
      get :artists
    end
  end

  


end