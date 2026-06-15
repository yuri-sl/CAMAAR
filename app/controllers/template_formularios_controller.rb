class TemplateFormulariosController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_template, only: [:edit, :update]

  def new
    @template_formulario = TemplateFormulario.new
  end

  def create
    
  end

  def edit

  end

  def update

  end

  private

  def set_template
    @template_formulario = TemplateFormulario.find(params[:id])
  end

  def template_params
    params.require(:template_formulario).permit(
      :nome_template,
      perguntas_attributes: [:id, :enunciado, :tipo_pergunta, :gabarito_discursiva, :gabarito_radio, :opcoes_radio, :_destroy]
    )
  end
end