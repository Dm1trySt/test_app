Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users do
    member do
      post :refresh_key
    end
  end

  post 'login', to: 'authentication#login'
end
