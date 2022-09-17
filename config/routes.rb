Rails.application.routes.draw do
  resources :rides
  resources :users do
    collection do
      get "me"
    end
  end
  resources :locations
  resources :trips
  post "auth/login", to: "authentication#login"
end
