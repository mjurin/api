Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users, only: [ :index, :create ]
      resources :oauths, only: [ :create ]
      resources :sessions, only: [ :create ]
    end
  end


end
