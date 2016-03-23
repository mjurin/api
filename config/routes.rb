Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users, only: [ :index, :create, :update ]
      resources :oauths, only: [ :create ]
      resources :sessions, only: [ :create ]
    end
  end

end
