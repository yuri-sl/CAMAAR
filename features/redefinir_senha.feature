Feature: Redefinir senha do usuário

Scenario: Redefinição de senha realizada com sucesso
Given que o usuário está na tela de redefinição de senha
When ele coloca a nova senha no primeiro campo
And ele coloca a mesma nova senha no segundo campo
And ele clica em "mudar de senha"
Then o sistema deve mudar a senha de acesso desse usuário

Scenario: Redefinição de senha com campos diferentes
Given que o usuário está na tela de redefinição de senha
When ele coloca a nova senha no primeiro campo
And ele coloca uma nova senha diferente no segundo campo
And ele clica em "mudar de senha"
Then o sistema deve exibir uma mensagem de erro informando que as duas senhas não batem
