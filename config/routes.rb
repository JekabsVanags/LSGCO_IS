Rails.application.routes.draw do
  post '/session', to: 'session#create'
  get '/session', to: 'session#destory' # Using get to link to destory due to rails depriciation of link_to method specification
  get ':password/activation', as: 'activation', to: 'session#first_login'

  get '/profile', to: 'users#get'
  post 'users/:id/password_update', to: 'users#password_update', as: 'password_update'
  resources :users do
    member do
      post 'unit_update'
    end
  end

  root 'static#landing'
end
