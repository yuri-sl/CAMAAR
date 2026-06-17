FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Departamento #{n}" }
  end

  factory :user do
    sequence(:name) { |n| "Usuário #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :student }
    association :department

    trait :admin do
      role { :admin }
    end

    trait :coordinator do
      role { :coordinator }
    end
  end

  factory :turma do
    sequence(:name) { |n| "Turma #{n}" }
    sequence(:codigo) { |n| "CIC#{n.to_s.rjust(4, '0')}" }
    semester { "2024.1" }
    association :department
  end

  factory :enrollment do
    association :user
    association :turma
  end

  factory :formulario do
    sequence(:title) { |n| "Formulário #{n}" }
    description { "Descrição do formulário" }
    deadline { 1.week.from_now }
    association :created_by, factory: :user
    association :department
  end

  factory :questao do
    sequence(:enunciado) { |n| "Questão #{n}?" }
    required { true }
    position { 1 }
    association :formulario
  end

  factory :turma_formulario do
    association :turma
    association :formulario
  end

  factory :resposta do
    submitted_at { Time.current }
    association :user
    association :formulario
    association :turma
  end

  factory :resposta_questao do
    answer { "Resposta de teste" }
    association :resposta
    association :questao
  end
end
