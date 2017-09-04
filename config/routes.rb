Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
  end

  resources :users, only: [:new, :create]

  post 'users/confirm', to: 'users#confirm'

  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
