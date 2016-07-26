Rails.application.routes.draw do
  get 'seating' => 'seating#show'
  get 'seating/edit' => 'seating#edit'
  post 'table/:id' => 'seating#update'
  devise_for :users, :controllers => {registrations: 'registrations'} 

  resources :users
  resources :musics
  root to: "landing#index"

  as :user do
  	get "/login" => "devise/sessions#new"
  	get "/logout" => "devise/sessions#destroy"
  	get "/rsvp" => "rsvp#index"
	get "/music/new" => "musics#new"
	get "/music" => "musics#index"
	post "/musics/new" => "musics#new"
  	get "/music/new" => "musics#new"
  	get "/music" => "musics#index"
        get 'seating' => 'seating#show'
	get 'table/:id/remove/:seat_id' => 'seating#remove'
	post 'table/:id' => 'seating#update'
  	post "/" => "landing#index"
  	post "/rsvp" => "rsvp#submit"
  end
end
