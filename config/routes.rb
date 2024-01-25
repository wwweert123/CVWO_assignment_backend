Rails.application.routes.draw do
  resources :authors
  namespace :api do
    namespace :v1 do 
      resources :forum_threads do
        member do
          get "likestatus" => "forum_threads#likestatus"
          put "like" => "forum_threads#like"
        end
      end
      resources :comments, only: [:create, :destroy] do
        member do
          get "likestatus" => "comments#likestatus"
          put "like" => "comments#like"
        end
      end
      resources :authors do
        collection do
          get :forum_threads
          get :comments
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
