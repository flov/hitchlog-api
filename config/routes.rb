Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }

  resources :rides
  resources :posts do
    member do
      post :create_comment
    end
  end
  resources :users do
    member do
      get "profile"
      get "geomap"
      post "send_message"
    end
    collection do
      post "contact_form"
      post "confirm"
      get "me"
    end
  end
  resources :trips do
    collection do
      get "latest"
    end
    member do
      post :create_comment
    end
  end
  get "data/country_map", to: "data#country_map"
  get "data/trips_count", to: "data#trips_count"
  get "data/written_stories", to: "data#written_stories"
end
