Mapapp::Application.routes.draw do

  get 'search' => 'index#search'
  get 'counts' => 'index#counts'

  root :to => 'index#index'

  resources :categories, :only => [:index]
  resources :objects, :only => [:show]
  resources :places, :only => [:show]
  resources :buildings, :only => [:show]
  resources :streets, :only => [:show]

  resources :pages, :only => [:show]

  resources :photos, :only => [:index]

end
