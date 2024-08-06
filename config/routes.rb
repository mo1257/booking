Rails.application.routes.draw do
  get 'home/index'
  devise_for :users 

  resources :users do
    collection do
      get 'account', to: 'users#account'
      get 'profile', to: 'users#profile'
      get 'profile/edit', to: 'users#profile_edit'
      patch 'profile', to: 'users#update'
    end
  end

  root to: 'home#index'

  resources :rooms do
    collection do
      get 'search'
    end

    resources :reviews, only: [:create, :destroy]
    resources :reservations, only: [:new, :create]
  end

  resources :reservations, only: [:index, :show, :edit, :update] do
    member do
      get 'confirmation'
      post 'confirm'
    end
  end
end
