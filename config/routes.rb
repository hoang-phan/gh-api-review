Rails.application.routes.draw do
  resources :repositories, only: [:index, :show, :create, :update]
  resources :branches, only: [:show, :create, :update]
  resources :commits, only: [:index, :show, :create]

  root to: 'repositories#index'
end
