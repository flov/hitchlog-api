Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
  get "/members", to: "members#show"
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
  post "auth/login", to: "authentication#login"
end
