require "csv"

class RelatoriosController < ApplicationController
  before_action :require_admin
  before_action :set_formulario, only: [:show, :export_csv]

  def index
    @formularios = Formulario.includes(:respostas).all
  end

  def show
    @questoes = @formulario.questoes.includes(:resposta_questoes)
    @total_respostas = @formulario.respostas.count
  end

  def export_csv
    respostas = @formulario.respostas.includes(:user, :turma, :resposta_questoes)
    questoes = @formulario.questoes.to_a

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Estudante", "Email", "Turma", "Data de envio"] + questoes.map(&:enunciado)

      respostas.each do |resposta|
        row = [
          resposta.user.name,
          resposta.user.email,
          resposta.turma.name,
          resposta.submitted_at.strftime("%d/%m/%Y %H:%M")
        ]
        questoes.each do |q|
          rq = resposta.resposta_questoes.find { |rq| rq.questao_id == q.id }
          row << (rq&.answer || "")
        end
        csv << row
      end
    end

    send_data csv_data,
      filename: "relatorio_#{@formulario.id}_#{Date.today}.csv",
      type: "text/csv",
      disposition: "attachment"
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end
