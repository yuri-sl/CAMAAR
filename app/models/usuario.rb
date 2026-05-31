class Usuario < ApplicationRecord
  enum :role, {
    admin: 0,
    professor: 1,
    estudante: 2
  }
  has_one :professor
  has_one :admin
  has_one :estudante
  has_one :criador_formulario

  has_many :resposta_formularios
end
