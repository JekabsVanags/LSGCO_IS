Rails.application.routes.draw do
  #Aplikācijas sesijas ceļi
  post "/session", to: "session#create"
  get "/session", to: "session#destroy" # Using get to link to destroy due to rails depriciation of link_to method specification

  #Lietotāja daļas ceļi
  get ":password/aktivizet", to: "session#first_login", as: "aktivizet"

  get "/profils", to: "users#profile"
  post "lietotajs/:id/atjaunot_paroli", to: "users#password_update"
  resources :users, path: :lietotajs do
    member do
      post "unit_update"
      post "password_update"
      post "promise"
    end
  end

  #Aptaujas lapas ceļi. Neizmantojam resources, jo aptaujas lapa ir piesaistīta katram lietotājam
  get "/aptaujas_lapa", to: "personal_information#show"
  delete "/aptaujas_lapa", to: "personal_information#destroy"
  get "/aptaujas_lapa/iesniegt", to: "personal_information#new"
  post "/aptaujas_lapa/iesniegt", to: "personal_information#create"
  patch "/aptaujas_lapa/iesniegt", to: "personal_information#update"
  get "/aptaujas_lapa/labot", to: "personal_information#edit"

  #Vienības darbības sfēras ceļi
  resources :unit, path: :vieniba
  resources :positions, only: ["create", "destroy"]
  resources :weekly_activities, only: ["create", "destroy"]
  resources :membership_fee_payments, path: :biedra_naudas_maksajumi, only: ["create", "destroy"] do
    member do
      get "list"
    end
  end

  #Pasākumu ceļi
  resources :events, path: :pasakums
  resources :invites, only: ["create", "destroy"]

  #Lapa kurā nav vajadzīga reģistrācija
  root "static#landing"
end
