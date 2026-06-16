class DepartamentosController < ApplicationController
  before_action :require_coordinator
  before_action :set_departamento

  def index
    @turmas = @departamento.turmas.includes(:formularios)
    @formularios = Formulario.where(departamento: @departamento)
  end

  def show
    @turma = @departamento.turmas.find_by(id: params[:id])

    unless @turma
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento." and return
    end

    @turma_formularios = @turma.turma_formularios.includes(:formulario)
    @available_formularios = Formulario
      .where(departamento: @departamento)
      .where.not(id: @turma.formularios.pluck(:id))
  end

  private

  def set_departamento
    @departamento = current_user.departamento
    unless @departamento
      redirect_to root_path, alert: "Você não está associado a nenhum departamento."
    end
  end
end
