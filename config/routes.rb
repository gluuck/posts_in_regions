Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'regions#index'
  resources :regions, only: %i[index show] do
    resources :posts
  end
end
