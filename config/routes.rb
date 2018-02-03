Rails.application.routes.draw do
  get 'welcome/index' #get 'welcome/index' tells Rails to map requests by browser to "http://localhost:3000/welcome/index" > to the welcome controller's index action
  
  root 'welcome#index'  #root 'welcome#index' tells Rails to map requests to the "root of the application" to the "welcome controller's index action"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
