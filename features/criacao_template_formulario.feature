# language: pt

Funcionalidade: Criação de Template de Formulário
  Como administrador
  Quero visualizar e criar templates de formulários
  Para que eu possa organizar os modelos disponíveis para criação de formulários

  Cenário: Administrador visualiza lista de templates existentes
    Dado que estou logado como administrador
    E existem templates cadastrados no sistema
    Quando acesso a seção de templates
    Então vejo a lista de templates disponíveis

  Cenário: Administrador cria novo template
    Dado que estou logado como administrador
    Quando acesso a seção de templates
    E clico em "Novo Template"
    E preencho o nome do template com "Avaliação Docente 2024"
    E clico em "Salvar Template"
    Então o template "Avaliação Docente 2024" é criado com sucesso

  Cenário: Usuário sem permissão tenta acessar templates
    Dado que estou logado como estudante
    Quando tento acessar a seção de templates
    Então o sistema nega o acesso
    E vejo uma mensagem informando que não tenho permissão para acessar esta funcionalidade
