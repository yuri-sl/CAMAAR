class TurmaFormulario < ApplicationRecord
  self.table_name = "turma_formularios"

  belongs_to :turma
  belongs_to :formulario

  validates :turma_id, uniqueness: { scope: :formulario_id }
end
