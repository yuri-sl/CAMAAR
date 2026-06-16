SENHA_FORM_PENDENTES = 'Senha123'

# Background

Given('que os seguintes usuários existam:') do |table|
  @usuarios = {}
  table.hashes.each do |row|
    email = row['email'].strip
    role  = row['perfil'].strip.downcase == 'estudante' ? :estudante : :professor

    usuario = Usuario.create!(
      nome:                  row['nome'].strip,
      email:                 email,
      password:              SENHA_FORM_PENDENTES,
      password_confirmation: SENHA_FORM_PENDENTES,
      role:                  role
    )

    profile = case role
              when :estudante then { estudante: Estudante.create!(usuario: usuario) }
              when :professor then { professor: Professor.create!(usuario: usuario) }
              end

    @usuarios[email] = { usuario: usuario }.merge(profile)
  end
end

# Given

Given('que o usuário esta logado como {string}') do |email|
  @usuario_logado = @usuarios[email]
  visit login_path
  fill_in 'Email', with: email
  fill_in 'Senha', with: SENHA_FORM_PENDENTES
  find('input[type="submit"]').click
end

Given('os seguintes formulários estão atribuidos ao usuário:') do |table|
  departamento = Departamento.find_or_create_by!(nome_departamento: 'Depto Formulários')
  materia = Materia.create!(
    codigoMateria: 'FPEND001',
    nome_materia:  'Matéria Formulários',
    departamento:  departamento
  )

  admin_u = Usuario.create!(
    nome:                  'Admin Criador',
    email:                 'admin.criador.form@escola.com',
    password:              'Admin123',
    password_confirmation: 'Admin123',
    role:                  :admin
  )
  criador  = CriadorFormulario.create!(usuario: admin_u)
  template = TemplateFormulario.create!(criador_formulario: criador)

  if @usuario_logado[:estudante]
    prof_u = Usuario.create!(
      nome:                  'Prof Turma Form',
      email:                 'prof.turma.form@escola.com',
      password:              SENHA_FORM_PENDENTES,
      password_confirmation: SENHA_FORM_PENDENTES,
      role:                  :professor
    )
    professor_turma = Professor.create!(usuario: prof_u)
    turma = Turma.create!(materia: materia, professor: professor_turma, semestre_string: '2026/1')
    Matricula.create!(estudante: @usuario_logado[:estudante], turma: turma)
    publico = true
  else
    turma  = Turma.create!(materia: materia, professor: @usuario_logado[:professor], semestre_string: '2026/1')
    publico = false
  end

  table.hashes.each do |row|
    Formulario.create!(
      nome_formulario:     row['nomeFormulario'].strip,
      template_formulario: template,
      turma:               turma,
      criador_formulario:  criador,
      publico_estudante:   publico
    )
  end
end

Given('não existem formulários atribuidos ao usuário') do
  # no-op — DatabaseCleaner garante estado limpo
end

Given('que o usuário não está logado') do
  # no-op — nenhuma sessão iniciada
end

# When

When('o usuário acessa a aba de {string}') do |_aba|
  visit avaliacoes_path
end

# Then

Then('ele deve ver {string}') do |texto|
  expect(page).to have_content(texto)
end

Then('o usuário deve ser redirecionado à página de Login') do
  expect(current_path).to eq(login_path)
end
