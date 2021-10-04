# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    get :flawed
    get :file
    get :data
  end
end
