Rails.application.routes.draw do
  root "home#index"

  # Authentication
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # Events with nested RSVPs
  resources :events do
    resource :rsvp, only: [:create, :destroy]
    # Host/Admin can cancel specific RSVPs
    delete "rsvps/:id", to: "rsvps#cancel", as: :cancel_rsvp
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
