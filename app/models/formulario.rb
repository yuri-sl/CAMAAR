class Formulario < ApplicationRecord
  belongs_to :template_formulario
  belongs_to :turma
  belongs_to :criador_formulario

  has_many :resposta_formularios
  has_many :pergunta_formularios
  has_many :perguntas, through: :pergunta_formularios
end
