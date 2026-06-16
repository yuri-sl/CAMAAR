class Questao < ApplicationRecord
  self.table_name = "questoes"

  belongs_to :formulario
  has_many :resposta_questoes, dependent: :destroy

  validates :enunciado, presence: true
  validates :position, presence: true
end
