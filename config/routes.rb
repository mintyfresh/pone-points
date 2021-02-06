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

  namespace :account, only: [] do
    resources :api_keys, only: %i[index show]

    get  :integrations
    get  :change_password
    post :change_password, action: :do_change_password
  end


  get  '/sign_in',  to: 'auth#sign_in'
  post '/sign_in',  to: 'auth#do_sign_in'
  get  '/sign_up',  to: 'auth#sign_up'
  post '/sign_up',  to: 'auth#do_sign_up'
  post '/sign_out', to: 'auth#sign_out'

  match '/auth/:provider/callback', to: 'auth#external', via: %i[get post]

  namespace :api do
    namespace :v1 do
      resources :pones, only: %i[index show], param: :slug do
        resources :achievements, only: :index, controller: 'pones/achievements'
        resources :points, only: %i[index show], controller: 'pones/points' do
          post :give, on: :collection
        end
      end
    end
  end
end
