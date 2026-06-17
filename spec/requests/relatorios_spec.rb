require "rails_helper"

RSpec.describe "Gerar Relatório do Administrador (issue #101)", type: :request do
  let(:department) { create(:department) }
  let(:admin) { create(:user, :admin, department: department) }
  let(:student) { create(:user, role: :student, department: department) }
  let(:turma) { create(:turma, department: department) }
  let(:formulario) { create(:formulario, department: department) }
  let!(:questao) { create(:questao, formulario: formulario, position: 1) }

  def login_as(user)
    post login_path, params: { email: user.email, password: "password123" }
  end

  def create_response_for(user)
    turma_formulario = create(:turma_formulario, turma: turma, formulario: formulario)
    resposta = create(:resposta, user: user, formulario: formulario, turma: turma)
    create(:resposta_questao, resposta: resposta, questao: questao, answer: "Resposta do estudante")
    turma_formulario
  end

  describe "Cenário: Administrador gera relatório de respostas de um formulário" do
    it "exibe o relatório com todas as respostas consolidadas e estatísticas" do
      create_response_for(student)
      login_as(admin)

      get relatorio_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(formulario.title)
      expect(response.body).to include(questao.enunciado)
      expect(response.body).to include("Resposta do estudante")
    end
  end

  describe "Cenário: Administrador exporta relatório em formato CSV" do
    it "realiza download de CSV com todas as respostas" do
      create_response_for(student)
      login_as(admin)

      get export_csv_relatorio_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("text/csv")
      expect(response.body).to include(student.name)
      expect(response.body).to include(student.email)
      expect(response.body).to include("Resposta do estudante")
    end
  end

  describe "Cenário: Administrador tenta gerar relatório de formulário sem respostas" do
    it "exibe mensagem informando que não há respostas registradas" do
      login_as(admin)

      get relatorio_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Não há respostas registradas")
    end
  end

  describe "Cenário: Usuário sem perfil de administrador tenta acessar relatórios" do
    it "nega o acesso e exibe mensagem de permissão negada" do
      login_as(student)

      get relatorios_path

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include("permissão")
    end
  end
end
