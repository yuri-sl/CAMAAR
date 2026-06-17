FactoryBot.define do
  sequence(:legacy_email) { |n| "legacy#{n}@example.com" }

  factory :legacy_usuario, class: "ApplicationRecord" do
    skip_create

    initialize_with do
      now = Time.current
      email = generate(:legacy_email)
      result = ActiveRecord::Base.connection.exec_insert(
        "INSERT INTO usuarios (nome, email, password_digest, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
        "Legacy Usuario",
        [
          ActiveRecord::Relation::QueryAttribute.new("nome", "Usuário Legado", ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("email", email, ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("password_digest", "password", ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("created_at", now, ActiveRecord::Type::DateTime.new),
          ActiveRecord::Relation::QueryAttribute.new("updated_at", now, ActiveRecord::Type::DateTime.new)
        ]
      )
      Struct.new(:id).new(result.rows.first.first)
    end
  end

  factory :legacy_departamento, class: "ApplicationRecord" do
    skip_create

    initialize_with do
      now = Time.current
      result = ActiveRecord::Base.connection.exec_insert(
        "INSERT INTO departamentos (nome_departamento, created_at, updated_at) VALUES (?, ?, ?)",
        "Legacy Departamento",
        [
          ActiveRecord::Relation::QueryAttribute.new("nome_departamento", "Departamento Legado", ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("created_at", now, ActiveRecord::Type::DateTime.new),
          ActiveRecord::Relation::QueryAttribute.new("updated_at", now, ActiveRecord::Type::DateTime.new)
        ]
      )
      Struct.new(:id).new(result.rows.first.first)
    end
  end

  factory :legacy_professor, class: "ApplicationRecord" do
    skip_create

    initialize_with do
      usuario = create(:legacy_usuario)
      now = Time.current
      result = ActiveRecord::Base.connection.exec_insert(
        "INSERT INTO professors (usuario_id, created_at, updated_at) VALUES (?, ?, ?)",
        "Legacy Professor",
        [
          ActiveRecord::Relation::QueryAttribute.new("usuario_id", usuario.id, ActiveRecord::Type::Integer.new),
          ActiveRecord::Relation::QueryAttribute.new("created_at", now, ActiveRecord::Type::DateTime.new),
          ActiveRecord::Relation::QueryAttribute.new("updated_at", now, ActiveRecord::Type::DateTime.new)
        ]
      )
      Struct.new(:id).new(result.rows.first.first)
    end
  end

  factory :legacy_materia, class: "ApplicationRecord" do
    skip_create

    initialize_with do
      departamento = create(:legacy_departamento)
      now = Time.current
      result = ActiveRecord::Base.connection.exec_insert(
        "INSERT INTO materia (nome_materia, codigoMateria, departamento_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
        "Legacy Materia",
        [
          ActiveRecord::Relation::QueryAttribute.new("nome_materia", "Matéria Legada", ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("codigoMateria", "LEG001", ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("departamento_id", departamento.id, ActiveRecord::Type::Integer.new),
          ActiveRecord::Relation::QueryAttribute.new("created_at", now, ActiveRecord::Type::DateTime.new),
          ActiveRecord::Relation::QueryAttribute.new("updated_at", now, ActiveRecord::Type::DateTime.new)
        ]
      )
      Struct.new(:id).new(result.rows.first.first)
    end
  end

  factory :legacy_criador_formulario, class: "ApplicationRecord" do
    skip_create

    initialize_with do
      usuario = create(:legacy_usuario)
      now = Time.current
      result = ActiveRecord::Base.connection.exec_insert(
        "INSERT INTO criador_formularios (usuario_id, created_at, updated_at) VALUES (?, ?, ?)",
        "Legacy Criador Formulario",
        [
          ActiveRecord::Relation::QueryAttribute.new("usuario_id", usuario.id, ActiveRecord::Type::Integer.new),
          ActiveRecord::Relation::QueryAttribute.new("created_at", now, ActiveRecord::Type::DateTime.new),
          ActiveRecord::Relation::QueryAttribute.new("updated_at", now, ActiveRecord::Type::DateTime.new)
        ]
      )
      Struct.new(:id).new(result.rows.first.first)
    end
  end

  factory :legacy_template_formulario, class: "ApplicationRecord" do
    skip_create

    initialize_with do
      criador = create(:legacy_criador_formulario)
      now = Time.current
      result = ActiveRecord::Base.connection.exec_insert(
        "INSERT INTO template_formularios (nome_template, criador_formulario_id, created_at, updated_at) VALUES (?, ?, ?, ?)",
        "Legacy Template Formulario",
        [
          ActiveRecord::Relation::QueryAttribute.new("nome_template", "Template Legado", ActiveRecord::Type::String.new),
          ActiveRecord::Relation::QueryAttribute.new("criador_formulario_id", criador.id, ActiveRecord::Type::Integer.new),
          ActiveRecord::Relation::QueryAttribute.new("created_at", now, ActiveRecord::Type::DateTime.new),
          ActiveRecord::Relation::QueryAttribute.new("updated_at", now, ActiveRecord::Type::DateTime.new)
        ]
      )
      Struct.new(:id).new(result.rows.first.first)
    end
  end

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
    sequence(:numero_turma)
    semestre_string { "2024.1" }
    nota_turma { 0.0 }
    materia_id { create(:legacy_materia).id }
    professor_id { create(:legacy_professor).id }
    association :department
  end

  factory :enrollment do
    association :user
    association :turma
  end

  factory :formulario do
    sequence(:title) { |n| "Formulário #{n}" }
    sequence(:nome_formulario) { |n| "Formulário Legado #{n}" }
    description { "Descrição do formulário" }
    deadline { 1.week.from_now }
    association :created_by, factory: :user
    association :department
    association :turma
    publico_estudante { true }
    criador_formulario_id { create(:legacy_criador_formulario).id }
    template_formulario_id { create(:legacy_template_formulario).id }
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
