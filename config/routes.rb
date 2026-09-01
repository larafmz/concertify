Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  get "change_locale/:locale", to: "application#change_locale", as: :change_locale
  
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :users, only: [:show, :index] do
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
      get :notifications
    end
  end
  
  resources :registers, only: [:index, :edit, :update, :new, :create]
  
  resources :chats, only: [:index, :show] do
    member do
      post :send_message
      delete :exit
      post :mark_as_read
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

  resources :comments, only: [:show] do
    member do
      post :reply
    end
  end

  resources :future_assistances, only: [:new, :create, :destroy, :edit, :update]

  resources :publications, only: [:index, :new, :create, :show, :destroy]

  resources :artists, only: [:show, :index, :edit, :update] do
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
  end

  resources :events, only: [:show, :index] do
    member do
      post :post
      get :registers
      get :future_assistances
      get :publications
      get :artists
    end
  end

  resources :requests, only: [:index, :new, :create, :destroy, :edit, :update]

  resources :notifications do
    member do
      post :mark_as_read
      post :read_and_redirect
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