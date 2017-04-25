Rails.application.routes.draw do
  namespace :admin do
    resources :boards
    resources :sketches
    resources :users

    root to: "boards#index"
  end

  namespace :api do
    resources :board do
      collection do
        post :register
        post :deregister
        post :alexa
      end
    end
    resources :sketch, only: [:index, :show, :create, :update, :destroy]
    resources :links, only: [:index]
    resources :code_snippet, only: [:index]
    resources :marketplace, only: [:index] do
      collection do
        post :purchase
      end
    end
    resources :sessions, only: [:create]
  end

  mount ActionCable.server => "/cable"

  root to: 'admin/boards#index'
end
