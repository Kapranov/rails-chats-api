Rails.application.routes.draw do
  resource :session, only: [:create, :destroy]
  resource :profile, only: [:update, :show, :destroy]
end
