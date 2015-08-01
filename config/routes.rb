Rails.application.routes.draw do  

  devise_for :users
  resources :videos
  resources :collections
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'

  # Example of regular route:

  post '/videos/filters' => 'videos#filters'

  post '/videos/filters_test' => 'videos#filters_test'

  post '/videos/save_kpop_fields' => 'videos#save_kpop_fields'
  post '/videos/create_likes' => 'videos#create_likes'
  post '/videos/add_collection' => 'videos#add_collection'
  post '/videos/add_to_new_collection' => 'videos#add_to_new_collection'

  get '/videos' => 'videos#index'

  get '/admin' => 'admin#index'

  get '/admin/users' => 'admin#users'
  post '/admin/users/admin' => 'admin#toggle_user_admin'


  # get '/filterby/:field/:from/:to' => 'videos#filter_by'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):    


  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
