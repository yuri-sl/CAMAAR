class RespostasController < ApplicationController
  before_action :require_login

  def create
    @formulario = find_formulario
    return unless @formulario

    estudante = find_estudante
    return unless estudante

    return unless estudante_tem_permissao?(estudante, @formulario)
    return unless resposta_unica?(@formulario)

    @pergunta_formularios = @formulario.pergunta_formularios
    return unless respostas_preenchidas?(params[:respostas])

    resposta = RespostaFormulario.new(formulario: @formulario, usuario: current_usuario)

    if resposta.save
      redirect_to avaliacoes_path, notice: "Sua resposta foi registrada com sucesso."
    else
      flash.now[:alert] = "Erro ao registrar resposta."
      render "formularios/show", status: :unprocessable_entity
    end
  end

  private

  def find_formulario
    @formulario = Formulario.find_by(id: params[:formulario_id])
    unless @formulario
      redirect_to avaliacoes_path, alert: "Formulário não encontrado."
      return nil
    end
    @formulario
  end

  def find_estudante
    estudante = current_usuario.estudante
    unless estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário."
      return nil
    end
    estudante
  end

  def estudante_tem_permissao?(estudante, formulario)
    turma_ids = estudante.matriculas.where(trancado: [ false, nil ]).pluck(:turma_id)
    unless turma_ids.include?(formulario.turma_id) && formulario.publico_estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário."
      return false
    end
    true
  end

  def resposta_unica?(formulario)
    if RespostaFormulario.exists?(formulario: formulario, usuario: current_usuario)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return false
    end
    true
  end

  def respostas_preenchidas?(respostas_params)
    answers = respostas_params || {}
    missing = @pergunta_formularios.any? { |pf| answers[pf.id.to_s].blank? }

    if missing
      flash.now[:alert] = "Por favor, responda todas as questões obrigatórias."
      render "formularios/show", status: :unprocessable_entity
      return false
    end
    true
  end
end
