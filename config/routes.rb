Rails.application.routes.draw do
  resources :rides
  resources :users
  resources :locations
  resources :trips
  post "auth/login", to: "authentication#login"
end
