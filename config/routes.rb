Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  get "/searchs", to: "searchs#index"
  get "change_locale/:locale", to: "application#change_locale", as: :change_locale
  
  devise_for :users

  resources :users, only: [:show, :edit, :update] do
    member do
      post :follow
      delete :unfollow
      post :block
      delete :unblock
      get :followers
      get :followings
      get :blocked
      get :registers
      get :diary
      get :future_assistances
      get :publications
      get :artists
      get :requests
    end
  end
  
  resources :registers, only: [:index, :edit, :update, :new, :create]
  
  resources :chats, only: [:index, :show] do
    member do
      post :send_message
      delete :exit
      post :read
    end
  end

  resources :interactuables, only: [:show, :destroy] do
    member do
      post :like
      post :repost
      post :comment
      delete :uncomment
      get :reposts
      get :comments
    end
  end

  resources :future_assistances, only: [:new, :create, :index, :destroy]

  resources :publications, only: [:index, :new, :create, :show]

  resources :artists, only: [:show, :index] do
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

  resources :events, only: [:show, :index, :new, :create, :destroy, :edit, :update] do
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

  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_read
    end
  end

  mount ActionCable.server => "/cable"

  # loads home when route doesnt exist (excepts for rails/active_storage routes; used to load photos)
  get "*unmatched_route",
    to: redirect("/"),
    constraints: ->(request) {
      !request.path.start_with?("/rails/active_storage")
    }

end