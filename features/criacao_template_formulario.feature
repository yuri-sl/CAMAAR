Feature: Criacao de Template de Formulario
Como Professor ou Administrador,
Para que eu possa avaliar turmas e ser especifico na minha avaliação,
Quero poder criar templates de formulario das quais criarei formularios futuramente



  Scenario: Chegar na página de Criação de Template de Formulário
    Given que o usuário tem permissões para criacao de Formulario
    And ele está na aba criação de Templates de Formulário
    When ele clica no botão "Criar Template"
    And escreve "<nomeTemplate>" em "Nome da Template de Formulário"
    And ele clica no botão "Montar Template" 
    Then o usuário deve estar na página de criação de Template de Formulário
    And ele deve ver "<nomeTemplate>"

  Examples:
  | nomeTemplate          |
  | Template Generica     |
  | Formulario de Opinião |

  Scenario: Criação de Pergunta tipo Discursiva
    Given que o usuário está montando um Template
    When ele seleciona "Discursiva" de "Tipo de Questão"
    And escreve "Pergunta?" em "Enunciado"
    And escreve "Resposta" em "Gabarito"
    And ele clica no botão "Adicionar Questão"
    Then ele deve ver "Pergunta?"

  Scenario: Criação de Pergunta tipo Radio
    Given que o usuário está montando um Template
    When ele seleciona "Radio" de "Tipo de Questão"
    And escreve "Opções" em "Enunciado"
    And ele seleciona "<quantidadeOpcoes>" de "Quantidade de Opções"
    And ele preenche as primeiras "<quantidadeOpcoes>" opções com:
      | texto_opcao |
      | <opcao1>   |
      | <opcao2>   |
      | <opcao3>   |
      | <opcao4>   |
      | <opcao5>   |
    And ele seleciona "<resposta>" de "Gabarito"
    And ele clica no botão "Adicionar Questão"
    Then ele deve ver "Opções"

    Examples:
    | quantidadeOpcoes | opcao1 | opcao2 | opcao3 | opcao4 | opcao5 | resposta |
    | 3                | Azul   | Verde  | Vermelho | N/A  | N/A    | Opção 1  |
    | 4                | Carro  | Moto   | Bike   | Trem   | N/A    | Opção 2  |
    | 5                | Alface | Tomate | Batata | Cebola | Alho   | Opção 3  |

  Scenario: Sucesso na criação de uma template de formulário de uma questão discursiva (Happy Path)
    Given que o usuário está montando o Template "<nomeTemplate>"
    When ele cria uma questão "Discursiva" com "<enunciado>" e "<gabarito>"
    And ele clica no botão "Criar Template"
    Then o usuário deve estar na aba criação de Templates de Formulário
    And ele deve ver "<nomeTemplate>"

  Examples:
  | nomeTemplate  | enunciado | resposta  |
  | Template Teste  | Pergunta? | Resposta! |
  | Resposta Aberta | Qual sua opinião sobre o curso? | Resposta aberta |
  | Se Conhecer | Fale um pouco sobre você! | Resposta pessoal  |

  Scenario: Sucesso na criação de uma template de formulário de uma questão tipo radio (Happy Path)
    Given que o usuário está montando o Template "<nomeTemplate>"
    When ele cria uma questão "Radio" com "<enunciado>" e "<resposta>" com "<quantidadeOpcoes>" opções:
      | texto_opcao |
      | <opcaoUm>   |
      | <opcaoDois> |
      | <opcaoTres> |
      | <opcaoQuatro> |
      | <opcaoCinco>  |
    And ele clica no botão "Adicionar Questão"
    And ele clica no botão "Criar Template"
    Then o usuário deve estar na aba criação de Templates de Formulário
    And ele deve ver "<nomeTemplate>"

  Examples:
  | nomeTemplate  | enunciado | quantidadeOpcoes  | opcaoUm | opcaoDois | opcaoTres | opcaoQuatro | opcaoCinco  | resposta  |
  | Template Teste  | Opções  | 3                 | 1       | 2         | 3         | N/A         | N/A         | Opção 3   |
  | Opinião Curso | Como você se sente sobre o curso? | 5 | Muito Bem | Bem | Neutro  | Mal       | Muito Mal   | Sem Gabarito  |
  | Matemática    | Quanto é 2+2? | 4             | 3       | 4         | 21        | 773.237     | N/A         | Opção 2   |

  Scenario: Sucesso na criação de uma template de formulário de uma questão discursiva e uma questão tipo radio (Happy Path)

  Examples:
  | nomeFormulario  |
  | formulario um   |
  | testeteste      |
  | Formulario Satisfação - CIC0105 |
  | Teste 3 - Formulario para Discentes |