class GerenciamentoController < ApplicationController
  before_action :require_login, only: [ :formularios, :criar_formulario ]
  before_action :autorizar_administrador, only: [ :formularios, :criar_formulario ]

  def index
  end

  def importar
    redirect_to gerenciamento_path, notice: "Importação iniciada."
  end

  def templates
  end

  def formularios
    preparar_formulario
  end

  def criar_formulario
    preparar_formulario
    @formulario.assign_attributes(formulario_params)
    @formulario.publico_estudante = publico_estudante
    @formulario.criador_formulario = current_usuario.criador_formulario

    unless @formulario.criador_formulario
      @formulario.errors.add(:base, "Administrador não possui perfil de criador de formulários.")
      return render :formularios, status: :unprocessable_content
    end

    if @formulario.save(context: :criacao_por_publico)
      redirect_to enviar_formularios_path, notice: "Formulário criado com sucesso."
    else
      render :formularios, status: :unprocessable_content
    end
  end

  def resultados
  end

  private

  def preparar_formulario
    @formulario ||= Formulario.new
    @templates = TemplateFormulario.order(:nome_template)
    @turmas = Turma.includes(:materia).order(:semestre_string, :numero_turma)
    @sem_templates = @templates.none?
  end

  def formulario_params
    params.require(:formulario).permit(:nome_formulario, :template_formulario_id, :turma_id)
  end

  def publico_estudante
    case params.dig(:formulario, :publico_alvo)
    when "discente" then true
    when "docente" then false
    end
  end

  def autorizar_administrador
    return if current_usuario&.admin?

    render plain: "Acesso negado, a criação de formulários requer privilégios de administrador",
           status: :forbidden
  end
end
