class Formulario < ApplicationRecord
  belongs_to :template_formulario, optional: true
  belongs_to :turma
  belongs_to :criador_formulario

  has_many :resposta_formularios
  has_many :pergunta_formularios
  has_many :perguntas, through: :pergunta_formularios

  after_create :vincular_perguntas_do_template

  validate :turma_possui_matricula_ativa, on: :criacao_por_publico
  validate :validar_ausencia_total, on: :criacao_por_publico
  validate :validar_campos_obrigatorios, on: :criacao_por_publico
  validate :formularios_duplicados, on: :criacao_por_publico

  private

  # Serve como validação para o caso em que o formulário de criação
  # de formulário está totalmente vazio.
  # 
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil. Adiciona erro com mensagem formatada caso necessário.
  def validar_ausencia_total
    if template_formulario.nil? && nome_formulario.presence.nil?
      errors.add(:base, "Formulario não pode ser criado, por favor preencha os dados necessários")
      return
    end
  end

  # Serve como validação para as variáveis básicas para criação de um formulário
  # (Nome do Formulário, Template para Criação, Público Alvo e Turma).
  #
  # Argumentos:
  # Não recebe argumentos.
  # 
  # Retorna:
  # Nil. Adiciona erro com mensagem formatada caso necessário.
  def validar_campos_obrigatorios
    return if errors.any?

    nome = nome_formulario.presence

    atributos_obrigatorios = [
      [nome.nil?, "o nome do formulário é obrigatório"],
      [template_formulario.nil?, "por favor seleciona uma Template"],
      [publico_estudante.nil?, "por favor selecione o Público-Alvo"],
      [turma.nil?, "por favor selecione uma Turma"]
    ]

    falhou, motivo_falha = atributos_obrigatorios.find { |condicao, _| condicao == true }

    if falhou
      errors.add(:base, "Formulario #{nome || 'sem nome'} não pode ser criado, #{motivo_falha}")
    end
  end

  # Serve como validação para o caso de existir um formulário aberto de mesmo nome
  # para o mesmo publico alvo e na mesma turma do formulario que se está criando.
  # 
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil. Adiciona erro com mensagem formatada caso necessário.
  def formularios_duplicados
    return if errors.any?

    nome = nome_formulario.presence

    if Formulario.where( nome_formulario: nome, turma_id: turma_id, publico_estudante: publico_estudante
              ).where.not(id: id).exists?
      errors.add(:base, "Formulario #{nome} não pode ser criado, já existe um formulário com este nome para a turma e público-alvo selecionados")
    end

  end

  # Serve como validação para o caso de não haver mátriculas em uma turma 
  # selecionada durante a criação de um formulário.
  # 
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil. Adiciona erro com mensagem formatada caso necessário.
  def turma_possui_matricula_ativa
    return unless publico_estudante?
    return if turma.nil?
    return if turma.matriculas.where(trancado: [ false, nil ]).exists?

    errors.add(:base, "Formulario #{nome_formulario} não pode ser criado, a turma selecionada não possui discentes matriculados")
  end

  # Cria uma instância de PerguntaFormulario para vincular ao formulário, em um padrão Snapshot.
  #
  # Argumentos:
  # Não recebe argumentos.
  # 
  # Retorna:
  # Nil. Serve apenas para criar os objetos PerguntaFormulario necessários.
  def vincular_perguntas_do_template
    template_formulario&.perguntas&.each do |pergunta|
      pergunta_formularios.create!(
        pergunta_id: pergunta.id,
        tipo_pergunta: pergunta.tipo_pergunta,
        enunciado: pergunta.enunciado,
        numero_opcoes: pergunta.numero_opcoes,
        opcoes_radio: pergunta.opcoes_radio,
        gabarito_radio: pergunta.gabarito_radio,
        gabarito_discursiva: pergunta.gabarito_discursiva
      )
    end
  end
end
