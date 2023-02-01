Rails.application.routes.draw do
  devise_for :users
  root "products#index"
  resources :products do
    member do
      delete :purge_one_attachment
      delete :purge_all_attachments
    end 
  end

  # delete 'PurgeAttachments/:id/purge', to: 'purge_attachments#purge_one_attachment', as: 'purge_one_attachment'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
