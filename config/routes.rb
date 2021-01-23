Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :posts do
        resources :comments
        resources :likes
        collection {get :search}
        collection {get :get_lat_lng}
        collection {get :map}
        member {get :ranking}
        member { get :likes }
        member { get :likes_users }
        member { get :data }
        member { get :data }
        
      end
      resources :users do
        collection {get :search}
        member { get :posts }
        member { get :likes_posts }
        member { get :data }
      end
      resources :user_images, only: [:update, :destroy]
     
    end
  end
end
