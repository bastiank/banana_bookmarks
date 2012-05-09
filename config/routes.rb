Bookmarks::Application.routes.draw do
  resources :bookmarks

  authenticated :user do
    root :to => 'bookmarks#index'
  end
  root :to => "bookmarks#index"
  devise_for :users
  #resources :users, :only => [:show, :index]
end
