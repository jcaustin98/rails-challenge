Rails.application.routes.draw do


  resources :experts
  post 'experts/search', action: :search, controller: 'experts'
end
