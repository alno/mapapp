Mapapp::Application.routes.draw do

  get 'search' => 'index#search'

  root :to => 'index#index'

  resources :categories, :only => [:index] do
    get :info, :on => :member
  end

  resources :objects, :only => [:show] do
    get :info, :on => :member
  end

  resources :places, :only => [:show] do
    get :info, :on => :member
  end

  resources :buildings, :only => [:show] do
    get :info, :on => :member
  end

  resources :streets, :only => [:show] do
    get :info, :on => :member
  end

  resources :pages, :only => [:show]

end
