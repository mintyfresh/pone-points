# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pones, only: :show

  get  '/sign_in', to: 'auth#sign_in'
  post '/sign_in', to: 'auth#do_sign_in'
end
