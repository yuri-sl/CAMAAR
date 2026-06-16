class RespostasController < ApplicationController
  before_action :require_login

  def create
    @formulario = Formulario.find_by(id: params[:formulario_id])

    unless @formulario
      redirect_to formularios_path, alert: "Formulário não encontrado." and return
    end

    enrolled_turma_ids = current_user.enrollments.pluck(:turma_id)
    turma_formulario = TurmaFormulario.find_by(formulario_id: @formulario.id, turma_id: enrolled_turma_ids)

    unless turma_formulario
      redirect_to formularios_path, alert: "Você não tem permissão para responder este formulário." and return
    end

    if @formulario.expired?
      redirect_to formularios_path, alert: "O prazo de resposta deste formulário foi encerrado." and return
    end

    if Resposta.exists?(user: current_user, formulario: @formulario, turma_id: turma_formulario.turma_id)
      redirect_to formularios_path, alert: "Você já respondeu este formulário." and return
    end

    answers = params[:respostas] || {}
    required_ids = @formulario.questoes.where(required: true).pluck(:id).map(&:to_s)
    missing = required_ids.any? { |id| answers[id].blank? }

    if missing
      @questoes = @formulario.questoes
      flash.now[:alert] = "Por favor, responda todas as questões obrigatórias."
      render "formularios/show", status: :unprocessable_entity and return
    end

    resposta = Resposta.new(
      user: current_user,
      formulario: @formulario,
      turma_id: turma_formulario.turma_id,
      submitted_at: Time.current
    )

    if resposta.save
      answers.each do |questao_id, answer_text|
        resposta.resposta_questoes.create!(questao_id: questao_id, answer: answer_text)
      end
      redirect_to formularios_path, notice: "Sua resposta foi registrada com sucesso."
    else
      @questoes = @formulario.questoes
      flash.now[:alert] = "Erro ao registrar resposta."
      render "formularios/show", status: :unprocessable_entity
    end
  end
end
