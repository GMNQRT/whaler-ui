Rails.application.routes.draw do

  root 'home#index'

  scope :partials do
    get '/home' => 'home#home'
    resources :images
    resources :containers
    get '/users/sign_in' => 'sessions#new'
    get '/users/sign_out' => 'registrations#new'
    get '/users/sign_up' => 'registrations#new'
  end

  get '*path' => 'home#index'
end
