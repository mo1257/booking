Rails.application.routes.draw do
  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users 
  resources  :users
  root to: 'home#index'
  #検索
  resources :rooms do
    collection do
      get 'search'
    end
  end
  #
  resources :rooms
end
