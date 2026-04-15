Rails.application.routes.draw do
  get '/health', to: 'health#index'
  get '/stats/year/:year', to: 'stats#year'

  resources :posts, only: %i[index show create]
  resources :disasters, only: %i[index show]
  resources :stories, only: %i[index show]

  namespace :admin do
    resources :stories
    resources :posts
    resources :stats
    resources :disasters

    root to: "stories#index"
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
