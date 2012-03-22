Mapapp::Application.routes.draw do

  get 'about' => 'index#about'
  get 'search' => 'index#search'

  root :to => 'index#index'

end
