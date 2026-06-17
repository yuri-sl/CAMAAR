class Formulario < ApplicationRecord
  self.table_name = "formularios"

  belongs_to :created_by, class_name: "User", foreign_key: :created_by_id
  belongs_to :department
  has_many :questoes, -> { order(:position) }, dependent: :destroy
  has_many :turma_formularios, dependent: :destroy
  has_many :turmas, through: :turma_formularios
  has_many :respostas, dependent: :destroy

  validates :title, presence: true
  validates :deadline, presence: true

  def expired?
    deadline < Time.current
  end

  def has_responses?
    respostas.any?
  end
end
