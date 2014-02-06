Easyblog::Application.routes.draw do
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :posts do
    member do
      post :mark_archived
    end
    resources :comments do
      member do
        post :vote_up
        post :vote_down
      end
    end
  end
end
