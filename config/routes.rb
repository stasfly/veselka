Rails.application.routes.draw do
  get 'static_pages/home', as: 'home'
  get 'static_pages/about_project', as: 'about_project'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :product_categories
    resources :cart_items, only: [:create, :update, :destroy]
    resources :carts, only: [:show]
    resources :orders, only: [:index, :show, :create]
    get     'customers',          to: 'admins#index',   as: 'users'
    get     'customer/:id',       to: 'admins#show',    as: 'user'
    get     'customer/:id/edit',  to: 'admins#edit',    as: 'user_edit'
    put     'customer/:id',       to: 'admins#update',  as: 'user_update'
    delete  'customer/:id',       to: 'admins#destroy', as: 'user_destroy'
    
    post  'csv_accept',   to: 'products#csv_accept'
    put   'bulk_update',  to: 'products#bulk_update'
    get   'csv_export',   to: 'products#csv_export'

    devise_for :users, controllers: {
      confirmations:  'users/confirmations', 
      passwords:      'users/passwords', 
      registrations:  'users/registrations',
      sessions:       'users/sessions'
    }
    root "static_pages#home"
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
