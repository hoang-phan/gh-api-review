Rails.application.routes.draw do
  resources :repositories, only: [:index, :create, :update, :show]
  resources :branches, only: [:create, :update, :show]
  resources :commits, only: [:index, :show]

  root to: 'repositories#index'
end
