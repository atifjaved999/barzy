Rails.application.routes.draw do
get '/api-docs' => redirect('/assets/swagger/dist/index.html?url=/assets/apidocs/api-docs.json')
  
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :admin, only: [:index]

  namespace :admin do
    resources :users
    resources :bars do
      resources :menus do
        resources :product_categories
      end
    end
    resources :categories
    resources :attachments, only: [:destroy]
    resources :need_helps, only: [:show, :index, :destroy]
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      as :user do
        resources :users, :except => [:create, :new, :edit, :destroy, :show] do
           collection do
              post '/login' => 'sessions#create'
              post '/social_login' => 'sessions#social_login'
              post '/register' => 'users#create'
              delete '/logout' => 'sessions#destroy'
              post '/forgot_password' => 'users#forgot_password'
              post '/reset_password' => 'users#reset_password'
              get 'favourite_bars'
            end
        end
      end
      resources :categories, only: [:index, :show] do
        resources :bars, only: [:index, :show]
      end



      resources :bars, only: [:index, :show] do
        collection do
          get :search
        end
        member do
          post :add_favourite
          post :remove_favourite
        end
      end
      resources :need_helps, only: [:create]
    end
  end

end
