When("acesso a seção de gerenciamento do departamento") do
  visit departamento_path
end

Then("vejo apenas as turmas vinculadas ao meu departamento") do
  expect(page).to have_content(@current_user.department.name)
end

Then("posso visualizar os formulários associados a cada turma") do
  expect(page).to have_content("Turmas")
end

Given("existe uma turma vinculada ao meu departamento") do
  @own_turma = create(:turma, department: @current_user.department)
end

Given("existe um formulário criado para o departamento") do
  @formulario = create(:formulario, department: @current_user.department)
end

When("seleciono a turma e associo o formulário") do
  visit departamento_path
  click_link @own_turma.name
  select @formulario.title, from: "formulario_id"
end

Then("o formulário fica disponível para os estudantes da turma") do
  expect(TurmaFormulario.exists?(turma: @own_turma, formulario: @formulario)).to be true
end

Then("vejo uma mensagem de confirmação da associação") do
  expect(page).to have_content("sucesso")
end

Given("existe uma turma vinculada a outro departamento") do
  other_department = create(:department)
  @other_turma = create(:turma, department: other_department)
end

When("tento acessar o gerenciamento dessa turma") do
  visit departamento_turma_path(@other_turma)
end

Then("vejo uma mensagem informando que a turma não pertence ao meu departamento") do
  expect(page).to have_content("não pertence ao seu departamento")
end

Given("existe uma turma do meu departamento com um formulário associado") do
  @own_turma = create(:turma, department: @current_user.department)
  @formulario = create(:formulario, department: @current_user.department)
  @turma_formulario = create(:turma_formulario, turma: @own_turma, formulario: @formulario)
end

When("seleciono a turma e removo a associação do formulário") do
  visit departamento_turma_path(@own_turma)
end

When("clico em \"Confirmar remoção\"") do
  click_button "Remover"
end

Then("o formulário deixa de estar disponível para os estudantes da turma") do
  expect(TurmaFormulario.exists?(turma: @own_turma, formulario: @formulario)).to be false
end

Then("vejo uma mensagem de confirmação da remoção") do
  expect(page).to have_content("removida com sucesso")
end
