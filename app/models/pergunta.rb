class Pergunta < ApplicationRecord
  belongs_to :template_formulario

  has_many :resposta_perguntas
  has_many :pergunta_formularios
  has_many :formularios, through: :pergunta_formularios
end
