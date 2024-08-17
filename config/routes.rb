Rails.application.routes.draw do
  get 'home/index'
  devise_for :users 
  
  resources :users do
    collection do
      get 'user/account', to: 'users#account', as: 'user_account'
      get 'user/account/edit', to: 'users#edit_account', as: 'edit_user_account'
      patch 'user/account', to: 'users#update_account', as: 'update_user_account'
      get 'account', to: 'users#account'
      get 'profile', to: 'users#profile', as: 'profile'
      get 'profile/edit', to: 'users#edit_profile', as: 'edit_profile'
      patch 'profile', to: 'users#update_profile', as: 'update_profile'
  end
end

  root to: 'home#index'

  resources :rooms do
    collection do
      get 'search'
    end
  get 'search_rooms', to: 'rooms#search', as: 'search_rooms'
  
    resources :reviews, only: [:create, :destroy]
    resources :reservations, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :reservations, only: [:index, :show, :edit, :update, :destroy] do
    member do
      get 'confirmation'
      post 'confirm'
    end
  end
end
