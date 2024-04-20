require 'sidekiq/web'
Rails.application.routes.draw do
	get 'admin/integrations', to: 'page#integrations'
	get 'admin/team', to: 'page#team'
	get 'admin/billing', to: 'page#billing'
	get 'admin/notifications', to: 'page#notifications'
	get 'admin/settings', to: 'page#settings'
	get 'admin/activity', to: 'page#activity'
	get 'admin/profile', to: 'page#profile'
	get 'admin/people', to: 'page#people'
	get 'admin/calendar', to: 'page#calendar'
	get 'admin/assignments', to: 'page#assignments'
	get 'admin/message', to: 'page#message'
	get 'admin/messages', to: 'page#messages'
	get 'admin/project', to: 'page#project'
	get 'admin/projects', to: 'page#projects'
	get 'admin/dashboard', to: 'page#dashboard'
	get 'pricing', to: 'page#pricing'
	get 'about', to: 'page#about'
  if Rails.env.development? || Rails.env.test?
    mount Railsui::Engine, at: "/railsui"
  end

  # Inherits from Railsui::PageController#index
  # To overide, add your own page#index view or change to a new root
  # Visit the start page for Rails UI any time at /railsui/start
  root action: :index, controller: "railsui/page"

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
    resources :categories
    resources :products
    resources :extras
    resources :flavors
    resources :delivery_locations
    resources :clerks
    resources :orders do
      member do
        get 'show_consumer'
        get 'show_products'
        get 'generate_pdf_receipt'
        patch 'update_status'
      end
    end
    get '', to: 'home#index', as: :home
    get 'config_delivery', to: 'config_deliveries#edit_config', as: :edit_config
    patch 'config_delivery', to: 'config_deliveries#update_config', as: :update_config
  end

  scope module: :external do
    get '', to: 'home#index', as: :home
    get 'stimulus', to: 'home#stimulus', as: :stimulus
  end
end
