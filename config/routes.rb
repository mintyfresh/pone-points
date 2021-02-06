# frozen_string_literal: true

Rails.application.routes.draw do
  resources :points, only: [] do
    get :recent, on: :collection
  end

  resources :pones, only: %i[index show] do
    resources :points, only: %i[create], controller: 'pones/points' do
      get :give, on: :collection
    end
  end

  get  '/change_password', to: 'profile#change_password'
  post '/change_password', to: 'profile#do_change_password'

  get  '/sign_in',  to: 'auth#sign_in'
  post '/sign_in',  to: 'auth#do_sign_in'
  get  '/sign_up',  to: 'auth#sign_up'
  post '/sign_up',  to: 'auth#do_sign_up'
  post '/sign_out', to: 'auth#sign_out'

  match '/auth/:provider/callback', to: 'auth#external', via: %i[get post]
end
