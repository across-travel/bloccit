Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
  end
  get 'about', to: 'welcome#about'

  root 'welcome#index'
end
