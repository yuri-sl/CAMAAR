class TurmaFormulariosController < ApplicationController
  before_action :require_coordinator

  def create
    @turma = current_user.department&.turmas&.find_by(id: params[:turma_id])

    unless @turma
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento." and return
    end

    @turma_formulario = TurmaFormulario.new(turma: @turma, formulario_id: params[:formulario_id])

    if @turma_formulario.save
      redirect_to departamento_turma_path(@turma), notice: "Formulário associado com sucesso."
    else
      redirect_to departamento_turma_path(@turma), alert: "Erro ao associar formulário."
    end
  end

  def destroy
    @turma_formulario = TurmaFormulario.find(params[:id])
    @turma = @turma_formulario.turma

    unless current_user.department&.turmas&.exists?(id: @turma.id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento." and return
    end

    @turma_formulario.destroy
    redirect_to departamento_turma_path(@turma), notice: "Associação de formulário removida com sucesso."
  end
end
