Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/help', as: 'help'
  get 'static_pages/about', as: 'about'
  get 'static_pages/contact', as: 'contact'
  get '/signup', to: 'users#new', as: 'signup'
  get '/signin', to: 'sessions#new', as: 'signin'
  post '/signin', to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
