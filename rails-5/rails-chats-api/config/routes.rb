Rails.application.routes.draw do
  #resource :session, only: [:create, :destroy]
  #resource :profile, only: [:create, :show]
  post    "/sessions", to: "sessions#create",  defaults: {format: 'json'}
  #delete  "/sessions", to: "sessions#destroy", defaults: {format: 'json'}
end
