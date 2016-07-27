Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations'} 

  resources :users
  resources :musics
  root to: "landing#index"

  as :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"

    get "/rsvp" => "rsvp#index"
    get "/rsvp/list_guests" => "rsvp#list_guests"
    get "/rsvp/add_guest/" => "rsvp#add_guest"
    get "/rsvp/remove_guest/:id" => "rsvp#remove_guest"
    get "/rsvp/list_guests" => "rsvp#list_guests"
    get "/rsvp/add_guest/:id" => "rsvp#add_guest"
    get "/rsvp/update_choices" => "rsvp#update_choices"
    get "/rsvp/update_user_choice" => "rsvp#update_user_choice"
    post "/rsvp" => "rsvp#submit"
    post "/rsvp/save_guests" => "rsvp#save_guests"

    get "/music/new" => "musics#new"
    get "/music" => "musics#index"
    post "/musics/new" => "musics#new"
    get "/music/new" => "musics#new"
    get "/music" => "musics#index"

    get 'seating' => 'seating#show'
    get 'table/:id/remove/:seat_id' => 'seating#remove'
    post 'table/:id' => 'seating#update'
    
    post "/" => "landing#index"

    
  end
  
end
