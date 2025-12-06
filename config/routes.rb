Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "users/signup", to: "users#signup"
  post "users/update_role", to: "users#update_role"

  post "amenities/create", to: "amenities#create"
  post "vendors/create", to: "vendors#create"
  post "apartments/create", to: "apartments#create"

end
