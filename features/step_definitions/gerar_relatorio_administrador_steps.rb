Given("existe um relatório gerado para um formulário") do
  dept = @department || create(:department)
  student = create(:user, role: :student, department: dept)
  @formulario = create(:formulario, department: dept)
  questao = create(:questao, formulario: @formulario)
  turma = create(:turma, department: dept)
  create(:enrollment, user: student, turma: turma)
  create(:turma_formulario, turma: turma, formulario: @formulario)
  resposta = create(:resposta, user: student, formulario: @formulario, turma: turma)
  create(:resposta_questao, resposta: resposta, questao: questao, answer: "Resposta do estudante")
  visit relatorio_path(@formulario)
end

When("acesso a seção de relatórios e seleciono o formulário") do
  visit relatorios_path
end

When("clico em \"Gerar relatório\"") do
  click_link "Ver relatório"
end

Then("o sistema exibe o relatório com todas as respostas consolidadas") do
  expect(page).to have_content(@formulario.title)
  expect(page).to have_content("Total de respostas")
end

Then("posso visualizar as estatísticas de cada questão") do
  expect(page).to have_content("Total de respostas para esta questão")
end

When("clico em \"Exportar CSV\"") do
  click_link "Exportar CSV"
end

Then("o sistema realiza o download de um arquivo CSV") do
  expect(page.response_headers["Content-Type"]).to include("text/csv")
end

Then("o arquivo contém todas as respostas dos estudantes") do
  expect(page.body).to include("Estudante")
  expect(page.body).to include("Email")
end

Then("não gera o relatório") do
  expect(page).to have_content("Não há respostas registradas")
end

When("tento acessar a seção de relatórios") do
  visit relatorios_path
end
