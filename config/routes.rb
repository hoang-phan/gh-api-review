Rails.application.routes.draw do
  resources :repositories, only: :index do
    collection do
      post :fetch
    end
  end
end
