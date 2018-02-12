Rails.application.routes.draw do


  resources :experts
  root 'experts#index'
end
