Rails.application.routes.draw do
  root 'regions#index' 
  resources :regions, only: [:index, :show]
end
