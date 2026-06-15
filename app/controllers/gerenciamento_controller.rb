class GerenciamentoController < ApplicationController
  def index
  end

  def importar
    redirect_to gerenciamento_path, notice: "Importação iniciada."
  end

  def templates
    @template_formularios = TemplateFormulario.all
  end

  def formularios
  end

  def resultados
  end
end

