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
        post :mark_as_not_abusive
      end
    end
  end
end
