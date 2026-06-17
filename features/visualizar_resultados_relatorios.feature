# language: pt

Funcionalidade: Visualização de Resultados dos Formulários
  Como administrador
  Quero visualizar os resultados dos formulários respondidos
  Para que eu possa analisar as avaliações realizadas

  Cenário: Administrador visualiza lista de formulários com resultados
    Dado que estou logado como administrador
    E existe um formulário com respostas registradas
    Quando acesso a seção de relatórios
    Então vejo a lista de formulários disponíveis
    E posso visualizar o número de respostas de cada formulário

  Cenário: Administrador acessa resultados de um formulário específico
    Dado que estou logado como administrador
    E existe um formulário com respostas registradas
    Quando acesso os resultados do formulário
    Então vejo as respostas consolidadas por questão

  Cenário: Administrador visualiza formulário sem respostas
    Dado que estou logado como administrador
    E existe um formulário que ainda não recebeu nenhuma resposta
    Quando acesso os resultados do formulário
    Então o sistema exibe uma mensagem informando que não há respostas registradas
