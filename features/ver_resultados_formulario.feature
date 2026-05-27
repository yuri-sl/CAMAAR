Feature: Ver os resultados dos formulários
Como Administrador ou Professor,
Para que eu possa analisar como foram as respostas para os meus formulários,
Quero poder ver os formulários que eu criei.

  Background: 
    Given que os seguintes usuários existam:
      | nome  | perfil    | email             | departamento  |
      | Igor  | Admin     | igor@escola.com   | CIC           |
      | Ana   | Professor | ana@escola.com    | CIC           |
      | Pedro | Professor | pedro@escola.com  | MUS           |
      | Julia | Estudante | julia@escola.com  | CIC           |
    And o departamento do/a "CIC" possui os seguintes formulários:
      | nomeFormulario                  | dono        |
      | Formulário Matéria 1 - Turma 2  | Professor1  |
      | Formulário Matéria 1 - Turma 7  | Professor1  |
      | Formulário Matéria 2 - Turma 2  | Professor1  |
      | Formulário Opcional             | Ana         |
      | Formulário Um                   | Ana         |
      | Formulário Introdutório         | Ana         |

  Scenario Outline: Professor vê seus formulários (Happy Path)
    Given que o usuário esta logado como "ana@escola.com"
    When o usuário acessa a aba de "Respostas Formulários"
    Then ele deve ver "Formulário Opcional"
    And ele deve ver "Formulário Um"
    And ele deve ver "Formulário Introdutório" 



  Scenario Outline: Administrador vê todos os formulários de um Departamento (Happy Path)
    Given que o usuário esta logado como "igor@escola.com"
    When o usuário acessa a aba de "Respostas Formulários"
    Then ele deve ver "Formulário Matéria 1 - Turma 2"
    And ele deve ver "Formulário Matéria 1 - Turma 7"
    And ele deve ver Formulário Matéria 2 - Turma 2"
    And ele deve ver "Formulário Opcional"
    And ele deve ver "Formulário Um"
    And ele deve ver "Formulário Introdutório" 






  Scenario: Tentativa de acesso a aba de Formulários Abertos sem estar logado (Sad Path)
    Given que o usuário não está logado 
    When o usuário acessa a aba de "Respostas Formulários"
    Then o usuário deve ser redirecionado à página de "Login"
    And ele deve ver "É necessário estar logado para acessar está página."

  Scenario: Tentativa de acesso a aba de Formulários Abertos sendo Aluno (Sad Path)
    Given que o usuário esta logado como "julia@escola.com"
    When o usuário acessa a aba de "Respostas Formulários"
    Then o usuário deve ser redirecionado à página de "Menu Principal"
    And ele deve ver "Usuário não tem as permissões necessárias para acessar a página."

  Scenario: Tentativa de acesso a aba de Formulários Abertos sem ser dono dos Formulários (Sad Path)
    Given que o usuário esta logado como "pedro@escola.com"
    When o usuário acessa a aba de "Respostas Formulários" de "ana@escola.com"
    Then o usuário deve ser redirecionado à página de "Menu Principal"
    And ele deve ver "Usuário não tem as permissões necessárias para acessar a página."