Rails.application.routes.draw do
    
devise_for :users
root to: "homes#top"
resources :post_images, only: [:new, :create, :index, :show, :destroy]
get "homes/about" => "homes#about", as: "about"
resources :users, only:[:show, :edit]
end
