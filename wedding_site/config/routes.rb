Rails.application.routes.draw do
  get 'seating' => 'seating#show'
  get 'seating/edit' => 'seating#edit'
  post 'table/:id' => 'seating#update'

  devise_for :users#, :controllers => {sessions: 'users/sessions'} 
  resources :users
  resources :musics
  root to: "landing#index"

  as :user do
  	get "/login" => "devise/sessions#new"
  	get "/logout" => "devise/sessions#destroy"
  	get "/rsvp" => "rsvp#index"
	post "/musics/new" => "musics#new"
  	post "/" => "landing#index"
  	post "/rsvp" => "rsvp#submit"
  end
end
