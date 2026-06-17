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

  def name
    return self[:name] if has_attribute?(:name)

    "Turma #{numero_turma}"
  end

  def name=(_value)
  end

  def codigo
    return self[:codigo] if has_attribute?(:codigo)

    "TURMA#{numero_turma}"
  end

  def codigo=(_value)
  end

  def semester
    return self[:semester] if has_attribute?(:semester)

    semestre_string
  end

  def semester=(value)
    self.semestre_string = value if has_attribute?(:semestre_string)
  end
end
