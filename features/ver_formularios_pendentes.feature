Feature: Ver formulários pendentes
Como Usuário (Professor ou Estudante),
Para que eu possa preencher os formulários atribuídos à mim,
Quero ver todos os formulários que preciso preencher em uma aba específica à este intuito.

  Scenario Outline: Usuário tem formulários pendentes (Happy Path)
    Given os seguintes formulários estão atribuidos ao usuário:
      | nomeFormulario  |
      | Formulário Opcional |
      | Formulário Um   |
      | Formulário Introdutório |
    When o usuário acessa a aba de "Formulários Pendentes"
    Then ele deve ver "Formulário Opcional"  
    And ele deve ver "Formulário Um"  
    And ele deve ver "Formulário Introdutório"  

  Scenario: Usuário não tem formulários pendentes (Happy Path)
    Given não existem formulários atribuidos ao usuário
    When o usuário acessa a aba de "Formulários Pendentes"
    Then ele deve ver "Você está em dia! Sem formulários para preencher."