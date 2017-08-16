Rails.application.routes.draw do
  
  resources :posts

  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
