Rails.application.routes.draw do

  root 'home#index'
  get '/home' => 'home#home'
  get '/images' => 'image#list'
  get '/container' => 'container#list', as: :container
  get '/users/sign_in' => 'sessions#new'
  get '/users/sign_up' => 'registrations#new'
end