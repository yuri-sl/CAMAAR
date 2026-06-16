class PerguntaFormulario < ApplicationRecord
  belongs_to :formulario
  belongs_to :pergunta, optional: true
end
