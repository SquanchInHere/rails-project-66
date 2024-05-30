# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    scope module: :auth do
      get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
      post 'auth/logout', to: 'auth#logout', as: :auth_logout
      post 'auth/:provider', to: 'auth#request', as: :auth_request
    end

    scope module: :repository do
      resources :repositories, only: %i[index show new create update] do
        resources :checks, only: %i[create show]
      end
    end
  end

  namespace :api do
    resources :check, only: %i[create]
  end
end
