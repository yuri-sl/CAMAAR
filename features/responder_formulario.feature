# language: pt

Funcionalidade: Responder Formulário
  Como estudante matriculado em uma turma
  Quero responder um formulário de avaliação disponibilizado pelo professor
  Para que minha avaliação seja registrada no sistema

  Cenário: Estudante responde formulário com sucesso
    Dado que estou logado como estudante
    E existe um formulário disponível para minha turma
    Quando acesso o formulário e preencho todas as questões
    E clico em "Enviar respostas"
    Então minha resposta é registrada no sistema
    E vejo uma mensagem de confirmação de envio

  Cenário: Estudante tenta responder formulário sem preencher todas as questões
    Dado que estou logado como estudante
    E existe um formulário disponível para minha turma
    Quando acesso o formulário e deixo questões obrigatórias sem resposta
    E clico em "Enviar respostas"
    Então o sistema não registra a resposta
    E vejo uma mensagem de erro indicando campos obrigatórios não preenchidos
