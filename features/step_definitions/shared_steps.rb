Given("estou logado como administrador") do
  @department = create(:department)
  @current_user = create(:user, :admin, department: @department)
  visit login_path
  fill_in "Email", with: @current_user.email
  fill_in "Senha", with: "password123"
  click_button "Entrar"
end

Given("estou logado como estudante") do
  @department = create(:department)
  @current_user = create(:user, role: :student, department: @department)
  visit login_path
  fill_in "Email", with: @current_user.email
  fill_in "Senha", with: "password123"
  click_button "Entrar"
end

Given("estou logado como coordenador de departamento") do
  @department = create(:department)
  @current_user = create(:user, :coordinator, department: @department)
  visit login_path
  fill_in "Email", with: @current_user.email
  fill_in "Senha", with: "password123"
  click_button "Entrar"
end

Given("estou logado como um usuário sem perfil de administrador") do
  @department = create(:department)
  @current_user = create(:user, role: :student, department: @department)
  visit login_path
  fill_in "Email", with: @current_user.email
  fill_in "Senha", with: "password123"
  click_button "Entrar"
end

Then("o sistema nega o acesso") do
  expect(page).to have_content("permissão")
end

Then("vejo uma mensagem informando que não tenho permissão para acessar esta funcionalidade") do
  expect(page).to have_content("permissão")
end

Given("existe um formulário com respostas registradas") do
  dept = @department || create(:department)
  student = create(:user, role: :student, department: dept)
  @formulario = create(:formulario, department: dept)
  questao = create(:questao, formulario: @formulario)
  turma = create(:turma, department: dept)
  create(:enrollment, user: student, turma: turma)
  create(:turma_formulario, turma: turma, formulario: @formulario)
  resposta = create(:resposta, user: student, formulario: @formulario, turma: turma)
  create(:resposta_questao, resposta: resposta, questao: questao, answer: "Resposta do estudante")
end

Given("existe um formulário que ainda não recebeu nenhuma resposta") do
  dept = @department || create(:department)
  @formulario = create(:formulario, department: dept)
end

Then("o sistema exibe uma mensagem informando que não há respostas registradas") do
  expect(page).to have_content("Não há respostas registradas")
end

When("tento acessar a seção de templates") do
  visit admin_templates_path
end

When("clico em \"Salvar\"") do
  click_button "Salvar"
end
