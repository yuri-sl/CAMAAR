class Formulario < ApplicationRecord
  belongs_to :template_formulario
  belongs_to :turma
  belongs_to :criador_formulario

  has_many :resposta_formularios
  has_many :pergunta_formularios
  has_many :perguntas, through: :pergunta_formularios

  after_create :vincular_perguntas_do_template

  validates :nome_formulario,
            presence: { message: "é obrigatório" },
            uniqueness: {
              scope: [ :turma_id, :publico_estudante ],
              message: "já existe para a turma e público-alvo selecionados"
            },
            on: :criacao_por_publico
  validates :template_formulario, presence: { message: "é obrigatório" }, on: :criacao_por_publico
  validates :turma, presence: { message: "é obrigatória" }, on: :criacao_por_publico
  validates :publico_estudante,
            inclusion: {
              in: [ true, false ],
              message: "deve ser Discente ou Docente"
            },
            on: :criacao_por_publico
  validate :turma_possui_matricula_ativa, on: :criacao_por_publico

  private

  def turma_possui_matricula_ativa
    return unless publico_estudante?
    return if turma&.matriculas&.where(trancado: [ false, nil ])&.exists?

    errors.add(:turma, "não possui discentes matriculados")
  end

  def vincular_perguntas_do_template
    template_formulario.perguntas.each do |pergunta|
      pergunta_formularios.create!(pergunta: pergunta)
    end
  end
end
