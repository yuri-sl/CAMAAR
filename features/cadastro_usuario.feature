Feature: Cadastro de Usuário

  Como visitante,
  Quero conseguir criar uma conta para mim mesmo
  Para que eu consiga ter acesso ao sistema

  Scenario: Cadastro realizado com sucesso
    Given que o usuário está na tela de cadastro
    When ele informa nome válido
    And informa email válido
    And informa uma senha válida
    Then o sistema deve cadastrar o usuário com sucesso

  Scenario: Cadastro com email já existente
    Given que o usuário está na tela de cadastro
    When ele informa um email já cadastrado
    And informa uma senha válida
    Then o sistema deve exibir uma mensagem de erro informando que o email já existe