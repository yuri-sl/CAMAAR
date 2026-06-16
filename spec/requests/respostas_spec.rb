require "rails_helper"

RSpec.describe "Responder Formulário (issue #99)", type: :request do
  let(:department) { create(:department) }
  let(:student) { create(:user, role: :student, department: department) }
  let(:turma) { create(:turma, department: department) }
  let(:formulario) { create(:formulario, department: department, deadline: 1.week.from_now) }
  let!(:enrollment) { create(:enrollment, user: student, turma: turma) }
  let!(:turma_formulario) { create(:turma_formulario, turma: turma, formulario: formulario) }
  let!(:questao) { create(:questao, formulario: formulario, required: true, position: 1) }

  def login_as(user)
    post login_path, params: { email: user.email, password: "password123" }
  end

  describe "Cenário: Estudante responde formulário com sucesso" do
    it "registra a resposta e exibe mensagem de confirmação" do
      login_as(student)

      post formulario_respostas_path(formulario),
        params: { respostas: { questao.id.to_s => "Minha resposta" } }

      expect(response).to redirect_to(formularios_path)
      follow_redirect!
      expect(response.body).to include("registrada com sucesso")
      expect(Resposta.count).to eq(1)
      expect(RespostaQuestao.last.answer).to eq("Minha resposta")
    end
  end

  describe "Cenário: Estudante tenta responder sem preencher questões obrigatórias" do
    it "não registra a resposta e exibe mensagem de erro" do
      login_as(student)

      post formulario_respostas_path(formulario),
        params: { respostas: { questao.id.to_s => "" } }

      expect(Resposta.count).to eq(0)
      expect(response.body).to include("obrigatórias")
    end
  end

  describe "Cenário: Estudante tenta acessar formulário fora do prazo" do
    let(:expired_formulario) { create(:formulario, department: department, deadline: 1.day.ago) }
    let!(:expired_turma_formulario) { create(:turma_formulario, turma: turma, formulario: expired_formulario) }

    it "não permite acesso e exibe mensagem de prazo encerrado" do
      login_as(student)

      get formulario_path(expired_formulario)

      expect(response).to redirect_to(formularios_path)
      follow_redirect!
      expect(response.body).to include("prazo")
    end
  end

  describe "Cenário: Estudante tenta acessar formulário de turma em que não está matriculado" do
    let(:other_student) { create(:user, role: :student, department: department) }

    it "nega o acesso e exibe mensagem de permissão negada" do
      login_as(other_student)

      get formulario_path(formulario)

      expect(response).to redirect_to(formularios_path)
      follow_redirect!
      expect(response.body).to include("permissão")
    end
  end
end
