Rails.application.routes.draw do
  root "posts#index"
  resources :posts, except: [:edit, :update] do
    resources :likes, only: :index, module: 'posts'
    resources :comments, except: [:show, :edit, :update], module: 'posts'
  end
  get 'comments/:id/likes', to: 'comments/likes#index', as: 'comment_likes'
  resources :users, only: [:index, :show] do
    resources :friends, only: [:index], controller: 'friendships'
  end
  resources :friends, only: [:create, :update, :destroy], controller: 'friendships', as: 'friendships'
  resources :notifications, only: [:index, :destroy]
  put '/notifications/:id', to: 'notifications#update_hidden', as: 'update_notification_hidden'
  resources :likes, only: [:create, :destroy]
  devise_for :users, path: 'accounts', controllers: { omniauth_callbacks: 'omniauth_callbacks',
                                                      registrations: 'users/registrations',
                                                      sessions: 'users/sessions',
                                                      passwords: 'users/passwords' }
  devise_scope :user do
    get '/accounts/complete', to: 'users/registrations#complete_edit'
    put '/accounts/complete', to: 'users/registrations#complete_update'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
