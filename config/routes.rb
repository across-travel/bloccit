Rails.application.routes.draw do

  get 'notifications', to: 'notifications#notifications'

  resources :invites, only: [:new, :create]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post '/private', to: 'users#private'
  post '/public', to: 'users#public'

  resources :topics do
    resources :posts, except: [:index]
  end

  resources :posts do
    resources :comments, only: [:create, :destroy], shallow: true do
      resources :comments, only: [:create]
    end
    post '/up-vote' => 'votes#up_vote', as: :up_vote
    post '/down-vote' => 'votes#down_vote', as: :down_vote
  end

  resources :users, only: [:new, :create, :show, :index] do
    member do
      get :following, :followers, :subscriptions
    end
  end

  resources :subscriptions, only: [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update]
      resources :topics, except: [:edit, :new]
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]

  get '/hashtag/:name', to: 'posts#hashtags'

  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
