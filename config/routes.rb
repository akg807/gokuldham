Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "users/signup", to: "users#signup"
  post "users/update_role", to: "users#update_role"

  post "requests/new", to: "requests#create"
  post "requests/request_approval", to: "requests#request_approval"
  get "requests/view_requests", to: "requests#view_requests"


  post "amenities/create", to: "amenities#create"
  post "vendors/create", to: "vendors#create"
  post "apartments/create", to: "apartments#create"

  post "entry_logs/logs", to: "entry_logs#logs"

  post "invoices/generate_maintenance", to: "invoices#generate_maintenance"
  get "invoices/user_pending_payments", to: "invoices#user_pending_payments"
  post "invoices/pay_maintenance", to: "invoices#pay_maintenance"

  get "analytics/prime_suspects", to: "analytics#prime_suspects"
  get "analytics/most_active_person", to: "analytics#most_active_person"
  get "analytics/top_defaulter", to: "analytics#top_defaulter"
end
