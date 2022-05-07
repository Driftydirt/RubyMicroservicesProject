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
  get 'login', to: 'sessions#new'
  post 'login/send', to: 'sessions#login'
  get 'home/reminder_email_test', to: 'home#reminder_email_test'
  get 'home/reset_email_test', to: 'home#reset_email_test'
  get 'reset_password_email', to: 'passwords#new'
  post 'reset_password_email_setup', to: 'passwords#reset_password_email_setup'
  get 'reset_password', to: 'passwords#edit'
  post 'reset_password_setup', to: 'passwords#reset_password_setup'
  get 'home/event_test', to: 'home#event_test'
  get 'home/created_event_test', to: 'home#created_event_test'
  get 'home/events_test', to: 'home#events_test'
  get 'home/update_event_test', to: 'home#update_event_test'
  post 'delete_event_setup', to: 'home#delete_event_setup', as: 'delete_event'
end
