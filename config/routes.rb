Rails.application.routes.draw do

  root 'home#index'
  get '/home' => 'home#home'
  get '/images' => 'image#list'
  get '/container' => 'container#list'
  get '/users/sign_in' => 'sessions#new'
  get '/users/sign_up' => 'registrations#new'

  resources :container do
  end
end