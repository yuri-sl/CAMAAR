Given("existe um formulário disponível para minha turma") do
  @turma = create(:turma, department: @current_user.department)
  create(:enrollment, user: @current_user, turma: @turma)
  @formulario = create(:formulario, department: @current_user.department, deadline: 1.week.from_now)
  @questao = create(:questao, formulario: @formulario, required: true)
  create(:turma_formulario, turma: @turma, formulario: @formulario)
end

When("acesso o formulário e preencho todas as questões") do
  visit formulario_path(@formulario)
  all("textarea").each { |ta| ta.set("Resposta de teste") }
end

When("clico em \"Enviar respostas\"") do
  click_button "Enviar respostas"
end

Then("minha resposta é registrada no sistema") do
  expect(Resposta.exists?(user: @current_user, formulario: @formulario)).to be true
end

Then("vejo uma mensagem de confirmação de envio") do
  expect(page).to have_content("registrada com sucesso")
end

When("acesso o formulário e deixo questões obrigatórias sem resposta") do
  visit formulario_path(@formulario)
end

Then("o sistema não registra a resposta") do
  expect(Resposta.exists?(user: @current_user, formulario: @formulario)).to be false
end

Then("vejo uma mensagem de erro indicando campos obrigatórios não preenchidos") do
  expect(page).to have_content("obrigatórias")
end

Given("existe um formulário cuja data de encerramento já passou") do
  @turma = create(:turma, department: @current_user.department)
  create(:enrollment, user: @current_user, turma: @turma)
  @formulario = create(:formulario, department: @current_user.department, deadline: 1.day.ago)
  create(:turma_formulario, turma: @turma, formulario: @formulario)
end

When("tento acessar o formulário") do
  visit formulario_path(@formulario)
end

Then("o sistema não permite o acesso ao formulário") do
  expect(page.current_path).not_to eq(formulario_path(@formulario))
end

Then("vejo uma mensagem informando que o prazo de resposta foi encerrado") do
  expect(page).to have_content("prazo de resposta")
end

Given("existe um formulário disponível para uma turma em que não estou matriculado") do
  other_dept = create(:department)
  other_turma = create(:turma, department: other_dept)
  @formulario = create(:formulario, department: other_dept, deadline: 1.week.from_now)
  create(:turma_formulario, turma: other_turma, formulario: @formulario)
end

When("tento acessar o formulário diretamente pela URL") do
  visit formulario_path(@formulario)
end

Then("vejo uma mensagem de erro informando que não tenho permissão para responder este formulário") do
  expect(page).to have_content("permissão para responder")
end
