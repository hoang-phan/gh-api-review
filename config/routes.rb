Rails.application.routes.draw do
  resources :repositories, only: [:index, :create, :update, :show]
  resources :branches, only: [:create, :update, :show]

  root to: 'repositories#index'
end
