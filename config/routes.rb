# -*- encoding : utf-8 -*-
Prima::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :filters do
    collection do
      post "create_filter"
      post "destroy_filter"
      post "add_value"
      post "change_name"
      post "change_flag"
    end
  end

  resources :suborders

  resources :products

  resources :banners

  resources :orders do
    collection do
      get "route"
      post "create_order"
      post "change_status"
    end
  end

  resources :categories do
      resources :products
  end

  resources :pages

  resources :users do
    collection do
      get "profile"
      get "list"
      # post "create_user"
      get "change_pass"
      post "checkemailvalid"
      post "change_pass_ajax"
      post "edit_user"
      post "destroy_user"
      # post "recover_pass"
      post "signout"
    end
  end

  root :to => 'pages#index'

  get '/profile',  :to => 'users#profile'
  get '/profile/:id',  :to => 'users#profile'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
