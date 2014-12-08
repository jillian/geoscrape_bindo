require 'sidekiq/api'

Rails.application.routes.draw do
  get 'scrape/run'

  mount Sidekiq::Web => '/current_tasks'


  get '/scrape', to: 'main#scrape'

  resources :businesses, only: [ :index ] do 
    get :get_markers, on: :collection
  end

  root 'businesses#index'
end