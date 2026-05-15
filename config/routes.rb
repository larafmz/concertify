Rails.application.routes.draw do
  get "home/index"
  root 'home#index'

  devise_for :users

  get "/searchs", to: "searchs#index"



end
