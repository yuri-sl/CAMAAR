Given("existe um template cadastrado no sistema") do
  @template = Template.create!(name: "Template Existente")
end

When("acesso a edição do template") do
  visit edit_admin_template_path(@template)
end

When("altero o nome para {string}") do |novo_nome|
  fill_in "Nome", with: novo_nome
end

Then("o template é atualizado com o nome {string}") do |nome|
  expect(page).to have_content(nome)
  expect(@template.reload.name).to eq(nome)
end

Then("vejo uma mensagem de confirmação de atualização") do
  expect(page).to have_content("sucesso")
end

Given("existe um template vinculado a um formulário") do
  dept = @department || create(:department)
  @template = Template.create!(name: "Template Com Formulário")
  @formulario_vinculado = create(:formulario, department: dept)
  @formulario_vinculado.update_column(:template_id, @template.id)
end

When("deleto o template") do
  visit admin_templates_path
  click_button "Excluir"
end

Then("o template é removido do sistema") do
  expect(Template.exists?(@template.id)).to be false
end

Then("o formulário vinculado continua existindo no sistema") do
  expect(Formulario.exists?(@formulario_vinculado.id)).to be true
end

Then("vejo uma mensagem de confirmação de remoção") do
  expect(page).to have_content("sucesso")
end
