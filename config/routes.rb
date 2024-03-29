require 'sidekiq/web'
Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', as: 'api_auth'
  devise_for :users
  mount Sidekiq::Web => '/sidekiq'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :admin_users,
             ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api, defaults: { format: :json } do
    namespace :goals do
      namespace :done do
        post :index
        post :show
        post :many
      end
    end
  end

  namespace :manager do
    resources :goals
    namespace :goals do
      namespace :done do
        post :one
        post :many
      end
    end

    get '', to: 'home#index', as: :home
  end

  scope module: :external do
    get '', to: 'home#index', as: :home
    get 'stimulus', to: 'home#stimulus', as: :stimulus
  end
end
