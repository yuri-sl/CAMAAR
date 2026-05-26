Feature: Importar dados do SIGAA
  Como um usuário de acesso privilegiado cadastrado no CAMAAR,
  Quero conseguir improtar dados diretamente do SIGAA
  Para que eu consiga criar preencher o banco de dados rapidamente

  Background:
    Given Usuário está na página de perfil de Gerenciamento

  Scenario: Importação realizada com sucesso
    When ele clica em "Importar dados"
    Then o sistema deve chamar a API do SIGAA
    And deve cadastrar os novos registros no banco de dados
    And deve exibir uma mensagem de sucesso com o total de registros importados

  Scenario: Falha de comunicação durante a importação com a API
    When ele clica em "Importar dados"
    Then o sistema deve chamar a API do SIGAA
    And ocorre uma falha na requisição para a API
    And deve exibir uma mensagem de erro relatando o erro na importação

  Scenario: Falha no formato de arquivos durante a importação
    When ele clica em "Importar dados"
    Then o sistema deve chamar a API do SIGAA
    And deve cadastrar os novos registros no banco de dados
    And algum dos campos recebidos da API não condiz com a estrutura do banco de dados
    And deve exibir uma mensagem de erro relatando falha na importação

