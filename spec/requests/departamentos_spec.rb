require "rails_helper"

RSpec.describe "Gerenciamento por Departamento (issue #106)", type: :request do
  let(:department) { create(:department) }
  let(:other_department) { create(:department) }
  let(:coordinator) { create(:user, :coordinator, department: department) }
  let(:own_turma) { create(:turma, department: department) }
  let(:other_turma) { create(:turma, department: other_department) }
  let(:formulario) { create(:formulario, department: department) }

  def login_as(user)
    post login_path, params: { email: user.email, password: "password123" }
  end

  describe "Cenário: Coordenador visualiza turmas do seu departamento" do
    it "exibe apenas as turmas vinculadas ao seu departamento" do
      own_turma
      other_turma
      login_as(coordinator)

      get departamento_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(own_turma.name)
      expect(response.body).not_to include(other_turma.name)
    end
  end

  describe "Cenário: Coordenador associa formulário a uma turma do departamento" do
    it "associa o formulário e exibe confirmação" do
      own_turma
      formulario
      login_as(coordinator)

      post turma_formularios_path,
        params: { turma_id: own_turma.id, formulario_id: formulario.id }

      expect(TurmaFormulario.count).to eq(1)
      expect(response).to redirect_to(departamento_turma_path(own_turma))
      follow_redirect!
      expect(response.body).to include("associado com sucesso")
    end
  end

  describe "Cenário: Coordenador tenta gerenciar turma de outro departamento" do
    it "nega o acesso e exibe mensagem de erro" do
      login_as(coordinator)

      get departamento_turma_path(other_turma)

      expect(response).to redirect_to(departamento_path)
      follow_redirect!
      expect(response.body).to include("não pertence ao seu departamento")
    end
  end

  describe "Cenário: Coordenador remove associação de formulário de uma turma" do
    it "remove a associação e exibe confirmação" do
      turma_formulario = create(:turma_formulario, turma: own_turma, formulario: formulario)
      login_as(coordinator)

      delete turma_formulario_path(turma_formulario)

      expect(TurmaFormulario.count).to eq(0)
      expect(response).to redirect_to(departamento_turma_path(own_turma))
      follow_redirect!
      expect(response.body).to include("removida com sucesso")
    end
  end
end
