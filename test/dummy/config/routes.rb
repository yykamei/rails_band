# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    get :flawed
    get :file
    get :data
    get :redirect
    get :callback
    get :notes
    get :welcome_email
    get :cache
    get :cache2
    get :cache3
    get :cache4
    get :deprecation
    get :message_serializer_fallback
    get :mailbox
  end

  resources :yay, only: %i[index show]

  resources :teams, only: %i[create show]
  post '/teams/preview', to: 'teams#preview'
  post '/teams/analyze', to: 'teams#analyze'
  post '/teams/transform', to: 'teams#transform'

  get 'old_users', to: redirect('/users')
  get 'special_stream', to: 'special_stream#index'
end
