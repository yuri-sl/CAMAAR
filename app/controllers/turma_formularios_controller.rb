class TurmaFormulariosController < ApplicationController
  before_action :require_coordinator

  def create
    @turma = find_turma_and_authorize(params[:turma_id])
    return unless @turma

    formulario = Formulario.find_by(id: params[:formulario_id])
    if formulario
      redirect_to departamento_turma_path(@turma), notice: "Formulário associado com sucesso."
    else
      redirect_to departamento_turma_path(@turma), alert: "Formulário não encontrado."
    end
  end

  def destroy
    formulario = find_formulario_and_authorize(params[:id])
    return unless formulario

    @turma = formulario.turma
    redirect_to departamento_turma_path(@turma), notice: "Associação de formulário removida com sucesso."
  end

  private

  # Retorna os IDs das turmas do departamento do usuário atual (memoizado)
  def turmas_do_departamento_ids
    @turmas_do_departamento_ids ||= begin
      departamento = current_usuario.admin&.departamento
      departamento&.materias&.flat_map(&:turmas)&.map(&:id) || []
    end
  end

  # Verifica se um ID de turma pertence ao departamento
  def turma_pertence_ao_departamento?(turma_id)
    turmas_do_departamento_ids.include?(turma_id)
  end

  # Localiza uma turma pelo ID e autoriza — redireciona se não encontrar ou não pertencer ao departamento
  def find_turma_and_authorize(turma_id)
    turma = Turma.find_by(id: turma_id)
    unless turma && turma_pertence_ao_departamento?(turma.id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento."
      return nil
    end
    turma
  end

  # Localiza um formulário pelo ID e autoriza verificando se sua turma pertence ao departamento
  def find_formulario_and_authorize(formulario_id)
    formulario = Formulario.find_by(id: formulario_id)
    unless formulario && turma_pertence_ao_departamento?(formulario.turma_id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento."
      return nil
    end
    formulario
  end
end
