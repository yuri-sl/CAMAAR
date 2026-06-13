Rails.application.routes.draw do
  root "login#index"
  get "login",to: "login#index"
  post "login", to: "login#create"
  delete "logout", to: "login#destroy"

  get "signup",to: "usuarios#new"
  post "signup",to: "usuarios#create"

  get "gerenciamento", to: "pages#gerenciamento"
  get "avaliacoes", to: "pages#avaliacoes"
  get "relatorios", to: "pages#relatorios"

  post "gerenciamento/importar",    to: "gerenciamento#importar",    as: :importar_dados
  get  "gerenciamento/templates",   to: "gerenciamento#templates",   as: :editar_templates
  get  "gerenciamento/formularios", to: "gerenciamento#formularios", as: :enviar_formularios
  post "gerenciamento/formularios", to: "gerenciamento#criar_formulario"
  get  "gerenciamento/resultados",  to: "gerenciamento#resultados",  as: :resultados



  get "login", to: "login#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
