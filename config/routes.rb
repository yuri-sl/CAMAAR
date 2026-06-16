Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get  "login",  to: "sessions#new",     as: :login
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :formularios, only: [:index, :show] do
    resources :respostas, only: [:create]
  end

  resources :relatorios, only: [:index, :show] do
    get :export_csv, on: :member
  end

  get  "departamento",            to: "departamentos#index", as: :departamento
  get  "departamento/turmas/:id", to: "departamentos#show",  as: :departamento_turma

  post   "turma_formularios",     to: "turma_formularios#create",  as: :turma_formularios
  delete "turma_formularios/:id", to: "turma_formularios#destroy", as: :turma_formulario

  root "sessions#new"
end
