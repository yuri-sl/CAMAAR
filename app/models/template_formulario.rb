class TemplateFormulario < ApplicationRecord
  belongs_to :criador_formulario

  has_many :formularios
  has_many :perguntas
end
