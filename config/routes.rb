Rails.application.routes.draw do

  root 'home#index'
  get '/home' => 'home#home'
  get '/images' => 'image#list'
  get '/container' => 'container#list'
  get '/users/sign_in' => 'sessions#new'
<<<<<<< HEAD
  get '/users/sign_out' => 'registrations#new'
=======
  get '/users/sign_up' => 'registrations#new'

  resources :container do
  end
>>>>>>> 20e6386bc11d5c5c028efea24506f4c4c43ae6eb
end