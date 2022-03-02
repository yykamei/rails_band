# frozen_string_literal: true

Rails.application.routes.default_url_options = { host: 'www.example.com' }

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
  end

  resources :yay, only: %i[index show]

  resources :teams, only: %i[create show]
end
