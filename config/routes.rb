Rails.application.routes.draw do 
  namespace :admins_backoffice do
    resources :admins      # Administradores
    resources :subjects    # Assuntos
    resources :questions   # Perguntas
    get 'welcome/index'    # DashBoard
    # get 'admins/index'
    # get 'admins/edit/:id', to: 'admins#edit'
  end
  namespace :site do
    get 'welcome/index'
    get 'search', to: 'search#questions'
    post 'answer', to: 'answer#question'
  end
  namespace :users_backoffice do
    get 'welcome/index'
  end

  devise_for :admins
  devise_for :users

  root 'site/welcome#index'
  get '/inicio', to: 'site/welcome#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
