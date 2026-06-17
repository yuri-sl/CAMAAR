class FormulariosController < ApplicationController
  before_action :require_login

  def index
    enrolled_turma_ids = current_user.enrollments.pluck(:turma_id)
    formulario_ids = TurmaFormulario.where(turma_id: enrolled_turma_ids).pluck(:formulario_id)
    @formularios = Formulario.where(id: formulario_ids).where("deadline >= ?", Time.current)
  end

  def show
    enrolled_turma_ids = current_user.enrollments.pluck(:turma_id)
    allowed_ids = TurmaFormulario.where(turma_id: enrolled_turma_ids).pluck(:formulario_id)

    @formulario = Formulario.find_by(id: params[:id])

    unless @formulario && allowed_ids.include?(@formulario.id)
      redirect_to formularios_path, alert: "Você não tem permissão para responder este formulário." and return
    end

    if @formulario.expired?
      redirect_to formularios_path, alert: "O prazo de resposta deste formulário foi encerrado." and return
    end

    @questoes = @formulario.questoes
  end
end
