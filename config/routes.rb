Rails.application.routes.draw do
  scope path: "(:locale)" do
    resources :cart_items, only: [:create, :update, :destroy]
    resources :carts, only: [:show]
    resources :orders, only: [:index, :show, :create]
    # get 'carts/show'
    # get 'orders/show'
    # post 'orders/create'
    # scope 'admin' do
      get 'admins/index', as: 'users'
      get 'admins/show', as: 'user'
      get 'admins/edit', as: 'user_edit'
      put 'admins/update', as: 'user_update'
      delete 'admins/destroy', as: 'user_destroy'
    # end

    devise_for :users, controllers: {
      registrations:  'users/registrations',
      sessions:       'users/sessions'
    }
    root "products#index"
    resources :products do
      member do
        delete :purge_one_attachment
        delete :purge_all_attachments
      end 
    end
  end
  # delete 'PurgeAttachments/:id/purge', to: 'purge_attachments#purge_one_attachment', as: 'purge_one_attachment'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
