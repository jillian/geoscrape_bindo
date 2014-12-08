require 'sidekiq/api'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/current_tasks'


  get '/scrape', to: 'scrape#run'

  resources :businesses, only: [ :index ] do 
    get :get_markers, on: :collection
  end

  root 'businesses#index'
end