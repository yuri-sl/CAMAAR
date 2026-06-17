module Admin
  class TemplatesController < ApplicationController
    before_action :require_admin
    before_action :set_template, only: [:edit, :update, :destroy]

    def index
      @templates = Template.all.order(:name)
    end

    def new
      @template = Template.new
    end

    def create
      @template = Template.new(template_params)
      if @template.save
        redirect_to admin_templates_path, notice: "Template criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @template.update(template_params)
        redirect_to admin_templates_path, notice: "Template atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @template.destroy
      redirect_to admin_templates_path, notice: "Template removido com sucesso."
    end

    private

    def set_template
      @template = Template.find(params[:id])
    end

    def template_params
      params.require(:template).permit(:name)
    end
  end
end
