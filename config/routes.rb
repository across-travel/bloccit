Rails.application.routes.draw do

  get 'msdf/show'

  resources :topics do
    resources :posts, except: [:index]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create, :destroy]

  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
