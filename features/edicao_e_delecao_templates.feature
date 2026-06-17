# language: pt

Funcionalidade: Edição e Deleção de Templates
  Como administrador
  Quero editar e deletar templates sem afetar formulários já criados
  Para que eu possa manter os modelos de formulários atualizados

  Cenário: Administrador edita um template existente
    Dado que estou logado como administrador
    E existe um template cadastrado no sistema
    Quando acesso a edição do template
    E altero o nome para "Template Atualizado"
    E clico em "Salvar"
    Então o template é atualizado com o nome "Template Atualizado"
    E vejo uma mensagem de confirmação de atualização

  Cenário: Administrador deleta um template sem afetar formulários existentes
    Dado que estou logado como administrador
    E existe um template vinculado a um formulário
    Quando deleto o template
    Então o template é removido do sistema
    E o formulário vinculado continua existindo no sistema
    E vejo uma mensagem de confirmação de remoção

  Cenário: Usuário sem permissão tenta acessar templates
    Dado que estou logado como estudante
    Quando tento acessar a seção de templates
    Então o sistema nega o acesso
