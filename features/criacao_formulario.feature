Feature: Criacao de Formulario

  Background:
    Given que os seguintes Templates existem:
      | templateName  |
      | default       |
      | APC - 2026.1  |
    And que eles contém as seguintes Perguntas estilo radio:
      | Enunciado     | gabaritoRadio | opcoesRadio |
      | Pergunta um   | 3 | Um, Dois, Tres, Quatro  |
      | Como se sente?  | 3 | Muito Favoravel, Favoravel, Neutro, Desfavoravel, Muito Desfavoravel  |

  Scenario: Criacao do Formulario com Sucesso (Happy Path)
    Given que o usuário tem permissões para criacao de Formulario
    And ele está na aba criação de formulários
    When ele clica no botão "Criar Formulário"
    And seleciona "<templateName> de "Templates"
    And ele clica no botão "Criar"
    Then o usuário deve estar na aba de criação de formulários
    And o formulário "<templateName>" deve existir


  Scenario: Falha na Criacao do Formulario (Sad Path)