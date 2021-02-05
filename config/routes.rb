# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pones, only: :show do
    resources :boons, only: %i[new create], controller: 'pones/boons'
  end

  get  '/sign_in', to: 'auth#sign_in'
  post '/sign_in', to: 'auth#do_sign_in'
  get  '/sign_up', to: 'auth#sign_up'
  post '/sign_up', to: 'auth#do_sign_up'
end
