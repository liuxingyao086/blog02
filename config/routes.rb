Rails.application.routes.draw do
  mount WeixinRailsMiddleware::Engine, at: "/"
  scope "/api/v1", defaults: { format: :json } do
    post 'user/login' => 'user_token#create'
    delete 'user/dislike/:article_id' =>'user#dislike'

    resources :user do
      collection do
        post 'register', only: :register
      end
      collection do
        get 'likes', only: :likes
      end
      post :avatar_upload, on: :collection
    end

    resources :users

    resources :articles do
      resources :comments
      collection do
        get 'my'
      end
      member do
        post 'like'
      end
      member do
        get 'likes'
      end
      member do
        put 'top'
      end
    end
  end
end
