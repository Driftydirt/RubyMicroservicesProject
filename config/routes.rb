Rails.application.routes.draw do
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'home#home'

  get 'user', to: 'user#show'
  get 'users/password/new', to: 'devise/passwords#new', as: 'password_reset'
  get 'home/test', to: 'home#test'
  get 'home/test_log_out', to: 'home#test_log_out'
  get 'home/test_auth', to: 'home#test_auth'
  get 'sign_up', to: 'registrations#new'
  post 'sign_up/send', to: 'registrations#sign_up'

end
