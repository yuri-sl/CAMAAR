When("acesso a seção de relatórios") do
  visit relatorios_path
end

Then("vejo a lista de formulários disponíveis") do
  expect(page).to have_content("Relatórios")
end

Then("posso visualizar o número de respostas de cada formulário") do
  expect(page).to have_content(@formulario.title)
  expect(page).to have_content(@formulario.respostas.count.to_s)
end

When("acesso os resultados do formulário") do
  visit relatorio_path(@formulario)
end

Then("vejo as respostas consolidadas por questão") do
  expect(page).to have_content("Resposta do estudante")
end
