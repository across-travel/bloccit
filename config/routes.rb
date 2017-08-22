Rails.application.routes.draw do

  resources :questions

  resources :posts

  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
