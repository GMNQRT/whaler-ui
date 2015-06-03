Rails.application.routes.draw do

  root 'home#index'

  scope :partials do
    get '/home' => 'home#home'
    get '/images' => 'image#list'
    get '/container' => 'container#list'
    get '/users/sign_in' => 'sessions#new'
    get '/users/sign_out' => 'registrations#new'
    get '/users/sign_up' => 'registrations#new'
  end

  get '*path' => redirect('/')
end