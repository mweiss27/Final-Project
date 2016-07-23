Rails.application.routes.draw do
  devise_for :users#, :controllers => {sessions: 'users/sessions'} 
  resources :users
  root to: "landing#index"

  as :user do
  	get "/login" => "devise/sessions#new"
  	get "/logout" => "devise/sessions#destroy"
  	post "/" => "landing#index"
  end
end
