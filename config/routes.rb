Mapapp::Application.routes.draw do

  get 'search' => 'index#search'

  root :to => 'index#index'

  resources :categories, :only => [:index] do
    get :page, :on => :member
  end

  resources :objects, :only => [:show] do
    get :page, :on => :member
  end

  resources :places, :only => [:show] do
    get :page, :on => :member
  end

  resources :buildings, :only => [:show] do
    get :page, :on => :member
  end

  resources :roads, :only => [:show] do
    get :page, :on => :member
  end

  resources :pages, :only => [:show]

end
