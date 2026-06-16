class Turma < ApplicationRecord
  belongs_to :department
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :user
  has_many :turma_formularios, dependent: :destroy
  has_many :formularios, through: :turma_formularios
  has_many :respostas, dependent: :destroy

  validates :name, presence: true
  validates :codigo, presence: true
  validates :semester, presence: true
end
