Rails.application.routes.draw do
  
  resources :advertisements

  resources :posts

  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
