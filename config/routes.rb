Rails.application.routes.draw do
  resources :repositories, only: [:index, :create]
  # resources :branches, only: [:index, :create]

  root to: 'repositories#index'
end
