Rails.application.routes.draw do

  # Defines the root path route ("/")
  root "pages#home"
  
  # Profile routes
  resource :profile, only: [:show, :edit, :update]
  get 'profiles/:id', to: 'profiles#show', as: :user_profile
  
  # Friendship routes
  resources :friendships, only: [:index, :create, :update, :destroy] do
    post 'accept', on: :member
    post 'reject', on: :member
  end
  
  # Posts
  resources :posts

  # User Registration (Sign up)
  resource :registrations, only: [:new, :create]

  # Session (Sign in / Log out)
  resource :session, only: [:new, :create, :destroy]

  # Password Reset using Token
  resources :passwords, param: :token

  # Search
  get 'search', to: 'search#index', as: :search

  # Health Check (for uptime monitoring)
  get "up", to: "rails/health#show", as: :rails_health_check

  # Friends
  get 'friends', to: 'friendships#index', as: :friends

  # Notifications
  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end

end
