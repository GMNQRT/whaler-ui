Rails.application.routes.draw do

  root 'application#layout'

  scope :partials do
    get '/dashboard' => 'dashboard#show'

    resources :images


    resources :containers do
      collection do
        get 'search'
      end
    end

    get '/users/sign_in' => 'sessions#new'

    get '/users/sign_out' => 'registrations#new'

    get '/users/sign_up' => 'registrations#new'

    get '/users' => 'registrations#index'
  end

  resource :api_config
  get '*path' => 'application#layout' # Redirect all to application's entry point
end
