Given("existem templates cadastrados no sistema") do
  @template1 = Template.create!(name: "Template Padrão")
  @template2 = Template.create!(name: "Template Avançado")
end

When("acesso a seção de templates") do
  visit admin_templates_path
end

Then("vejo a lista de templates disponíveis") do
  expect(page).to have_content("Templates")
end

When("clico em \"Novo Template\"") do
  click_link "Novo Template"
end

When("preencho o nome do template com {string}") do |nome|
  fill_in "Nome", with: nome
end

When("clico em \"Salvar Template\"") do
  click_button "Salvar Template"
end

Then("o template {string} é criado com sucesso") do |nome|
  expect(Template.exists?(name: nome)).to be true
end
