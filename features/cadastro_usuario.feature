Feature: Cadastro de Usuário

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