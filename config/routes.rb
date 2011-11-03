Ourvoyce::Application.routes.draw do
  match "/login" => 'sessions#login', :as => :login
  match "/logout" => 'sessions#logout', :as => :logout

  match '/signup' => 'users#new', :as => :sign_up

  match '/help' => 'sites#help', :as => :help
  match '/about' => 'sites#about', :as => :about
  match '/contact' => 'sites#contact', :as => :contact
  match '/donate' => 'sites#donate', :as => :donate
  match '/terms' => 'sites#terms', :as => :terms
  match '/privacy' => 'sites#privacy_policy', :as => :privacy_policy
  match '/membership' => 'sites#membership', :as => :membership

  match '/favorites(/:filter(/:sort))' => 'items#favorites', :as => :favorites
  match '/hot_topics(/:filter(/:sort))' => 'items#hot_topics', :as => :hot_topics
  match '/tag/:tag(/:filter(/:sort))' => 'items#tag', :as => :tag, :defaults => {:sort => 'default:all', :filter => 'all'}

  match '/utilities/generate_random_votes(/:count)' => 'utilities#generate_random_votes', :as => :generate_random_votes, :defaults => {:count => 100}

  match '/items/tag/:tag' => 'items#tag'
  match '/items/fetch' => 'items#fetch'
  resources :items do
    match "/vote" => "items#vote"
    match "/details" => "items#details"
    match "/toggle_favorite" => "items#toggle_favorite"
    match "/map(/:state)" => "items#map"
    match "/age(/:state)" => "items#age"
  end

  namespace :admin do
    resources :items
    resources :users
    resources :tags
  end

  root :to => 'defaults#index'
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
end
