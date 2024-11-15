Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }
  as :user do
    get 'users/sign_up' => 'devise/registrations#new'
  end
  root 'regions#index'
  resources :regions, only: %i[index show] do
    resources :posts
      post 'posts/:id/attach_files', to: 'posts#attach_files', as: :attach_files
      post 'posts/:id/attach_images', to: 'posts#attach_images', as: :attach_images
    resources :users, only: %i[show]
    patch 'posts/:id/change_state', to: 'posts#change_state', as: :change_state
  end

  get 'admin/posts', to: 'admin/posts#index', as: :admin_posts
end
