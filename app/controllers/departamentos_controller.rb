class DepartamentosController < ApplicationController
  before_action :require_coordinator
  before_action :set_department

  def index
    @turmas = @department.turmas.includes(:formularios)
    @formularios = Formulario.where(department: @department)
  end

  def show
    @turma = @department.turmas.find_by(id: params[:id])

    unless @turma
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento." and return
    end

    @turma_formularios = @turma.turma_formularios.includes(:formulario)
    @available_formularios = Formulario
      .where(department: @department)
      .where.not(id: @turma.formularios.pluck(:id))
  end

  private

  def set_department
    @department = current_user.department
    unless @department
      redirect_to root_path, alert: "Você não está associado a nenhum departamento."
    end
  end
end
