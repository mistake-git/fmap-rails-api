Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :posts do
        resources :comments
        resources :likes do
          collection {get :my_like}
        end
        collection {get :search}
        collection {get :get_lat_lng}
        collection {get :map}
        member {get :ranking}
        member { get :likes }
        member { get :likes_users }
        member { get :data }
        member { get :user }
      end

      resources :users do
        collection {get :search}
        member { get :feed }
        member { get :posts }
        member { get :likes_posts }
        member { get :followers }
        member { get :followings }
        member { get :data }
      end

      resources :user_images, only: [:update, :destroy]

      resources :relationships, only: [:create, :destroy]
      get 'relationships/is_followed', to: 'relationships#is_followed'
      resources :notifications, only: [:index]
      get 'notifications/check', to: 'notifications#check'
      get 'notifications/unchecked_notification_count', to: 'notifications#unchecked_notification_count'
      
    end
  end
end
