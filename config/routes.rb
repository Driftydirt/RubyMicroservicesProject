Rails.application.routes.draw do
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'home#home'

  get 'user', to: 'user#show'
  get 'users/password/new', to: 'devise/passwords#new', as: 'password_reset'
  get 'log_out', to: 'home#log_out_button'
  get 'sign_up', to: 'registrations#new'
  post 'sign_up/send', to: 'registrations#sign_up'
  get 'login', to: 'sessions#new'
  post 'login/send', to: 'sessions#login'
  get 'reset_password_email', to: 'passwords#new'
  post 'reset_password_email_setup', to: 'passwords#reset_password_email_setup'
  get 'reset_password', to: 'passwords#edit'
  post 'reset_password_setup', to: 'passwords#reset_password_setup'
  get 'create_event', to: 'events#new'
  post 'create_event/send', to: 'events#generate_event'
  get 'update_event', to: 'events#edit'
  post 'update_event/send', to: 'events#update_generated_event'
  post 'delete_event_setup', to: 'home#delete_event_setup', as: 'delete_event'
end
