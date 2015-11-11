Rails.application.routes.draw do

  root 'application#layout'

  scope :partials do
    get '/dashboard' => 'dashboard#show'

    resources :images


    resources :containers

    get '/users/sign_in' => 'sessions#new'

    get '/users/sign_out' => 'registrations#new'

    get '/users/sign_up' => 'registrations#new'
  end

  resource :api_config
  get '*path' => 'application#layout' # Redirect all to application's entry point
end
