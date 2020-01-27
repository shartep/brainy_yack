Rails.application.routes.draw do
  root 'homepage#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :articles
  # resources :stories

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :articles, only: %i[index create update destroy]
    end
  end

  # IMPORTANT #
  # This `match` must be the *last* route in routes.rb
  match '*path', to: 'homepage#index', via: :all
end
