Rails.application.routes.draw do

  # Rails matches the routes in the order defined in routes.rb and will call the controller action of the first matching route.
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Alternative-1
  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  # get 'signout', to: 'sessions#destroy', as: 'signout'

  # Alternative-2
  # get 'auth/:provider/callback' => 'sessions#create'
  # get 'auth/failure' => redirect('/')
  # get 'signout' => 'sessions#destroy', as: 'signout'


  get 'welcome/index' #get 'welcome/index' tells Rails to map requests by browser to "http://localhost:3000/welcome/index" > to the welcome controller's index action

  # post 'articles/view'
  resources :articles
  resources :questions
  resources :responses
  resources :users
  
  get 'articles/answer'# , :to => 'articles#answer'
  get 'articles/view'

  root 'welcome#index'  #root 'welcome#index' tells Rails to map requests to the "root of the application" to the "welcome controller's index action"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
