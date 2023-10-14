Rails.application.routes.draw do
  post '/session', to: 'session#create'
  get '/session', to: 'session#destory' #Using get to link to destory due to rails depriciation of link_to method specification

  get '/profile', to: 'users#get'


  root "static#landing"
end
