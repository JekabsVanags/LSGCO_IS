Rails.application.routes.draw do
  #Aplikācijas sesijas ceļi
  post "/session", to: "session#create"
  get "/session", to: "session#destroy" # Using get to link to destroy due to rails depriciation of link_to method specification

  #Lietotāja daļas ceļi
  get ":password/aktivizet", to: "session#first_login", as: "aktivizet"
  get ":password/atjaunot", to: "session#password_reset", as: "atjaunot"

  get "/profils", to: "users#profile"
  post "lietotajs/:id/atjaunot_paroli", to: "users#password_update"
  resources :users, path: :lietotajs do
    member do
      post "unit_update"
      post "password_update"
      post "promise"
      post "send_password_reset"
    end
  end

  #Aptaujas lapas ceļi. Neizmantojam resources, jo aptaujas lapa ir piesaistīta katram lietotājam
  get "/aptaujas_lapa", to: "personal_information#show"
  delete "/aptaujas_lapa", to: "personal_information#destroy"
  get "/aptaujas_lapa/iesniegt", to: "personal_information#new"
  post "/aptaujas_lapa/iesniegt", to: "personal_information#create"
  patch "/aptaujas_lapa/iesniegt", to: "personal_information#update"
  get "/aptaujas_lapa/labot", to: "personal_information#edit"
  get "/aptaujas_lapa/skatit", to: "personal_information#display"

  #Vienības darbības sfēras ceļi
  resources :units, path: :vieniba do
    member do
      patch "undestory"
    end
  end
  resources :positions, only: ["create", "destroy"]
  resources :weekly_activities, only: ["create", "destroy"]
  resources :membership_fee_payments, path: :biedra_naudas_maksajumi, only: ["create", "destroy"] do
    member do
      get "list"
    end
  end

  #Atskaišu ceļi
  get "/biedru_atskaites", to: "reports#member_report"
  get "/vienibas_atskaites", to: "reports#unit_report"

  #Pasākumu ceļi
  resources :events, path: :pasakums do
    member do
      get "show_unit"
    end
  end
  resources :invites, only: ["create", "destroy"]
  resources :event_registrations, only: ["create", "destroy", "show"]

  #Lapa kurā nav vajadzīga reģistrācija
  root "static#landing"
end
