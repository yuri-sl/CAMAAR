class RespostaQuestao < ApplicationRecord
  self.table_name = "resposta_questoes"

  belongs_to :resposta
  belongs_to :questao

  validates :questao_id, uniqueness: { scope: :resposta_id }
  validates :answer, presence: true, if: -> { questao&.required? }
end
