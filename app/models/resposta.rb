class Resposta < ApplicationRecord
  self.table_name = "respostas"

  belongs_to :user
  belongs_to :formulario
  belongs_to :turma

  has_many :resposta_questoes, dependent: :destroy

  validates :user_id, uniqueness: { scope: [:formulario_id, :turma_id] }
  validates :submitted_at, presence: true

  before_validation :set_submitted_at, on: :create

  private

  def set_submitted_at
    self.submitted_at ||= Time.current
  end
end
