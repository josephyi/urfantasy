require 'sidekiq/web'
Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

  get 'test' => 'test#index'
  get 'scoreboard/top/:day' => 'scoreboard#top'
  get 'champions/:champion_id' => 'champions#show'
  get 'stat/urf' => 'stat#urf', defaults: {   format: 'json' }
  get 'stat/champion/:champion_id' => 'stat#champion', defaults: {   format: 'json' }
  get 'stat/ranking/kills' => 'stat#kills', defaults: {   format: 'json' }
  get 'stat/ranking/kills/:region' => 'stat#kills', defaults: {   format: 'json' }


  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  mount Sidekiq::Web => '/sidekiq'
  get '*path' => 'application#index'
end
