Rails.application.routes.draw do
  devise_for :users
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'home#home'

  get 'user', to: 'user#show'
  get 'users/password/new', to: 'devise/passwords#new', as: 'password_reset'

end
