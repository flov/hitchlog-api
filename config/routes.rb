Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  resources :rides
  resources :users do
    member do
      get "profile"
      get "geomap"
    end
    collection do
      get "me"
    end
  end
  resources :trips

  get "data/country_map", to: "data#country_map"
  get "data/trips_count", to: "data#trips_count"
  get "data/written_stories", to: "data#written_stories"
end
