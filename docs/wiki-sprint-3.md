# Sprint 3 - Refatoracao, metricas e documentacao

## Objetivo da sprint

A Sprint 3 teve como foco melhorar a qualidade interna do codigo do CAMAAR por
meio de refatoracao, documentacao e acompanhamento de metricas. O objetivo foi
reduzir complexidade dos metodos, melhorar a cobertura de testes, manter os
cenarios BDD existentes funcionando e registrar os resultados antes e depois das
alteracoes.

As atividades foram organizadas em cinco frentes:

| Frente             | Responsabilidade | Situacao |
|--------------------|---|---|
| Yuri               | Infraestrutura das ferramentas e metricas iniciais | Concluido |
| João Victor Romero | Refatoracao dos controllers | Pendente de consolidacao |
| João Felipe Stein  | Refatoracao dos models e regras de negocio | Concluido |
| Artur              | Testes, cobertura e happy/sad path | Pendente de consolidacao |
| Luidgi             | Wiki, documentacao final e revisao do PR | Em andamento |

## Ferramentas usadas

| Ferramenta | Uso na sprint |
|---|---|
| SimpleCov | Medir cobertura de testes RSpec e Cucumber |
| RubyCritic | Gerar relatorio agregado de qualidade, duplicacao e smells |
| RuboCop Metrics | Medir complexidade ciclomatica e ABC Score por metodo |
| RDoc | Gerar documentacao a partir dos comentarios no codigo |

### Observacao sobre Saikuro e MetricFu

A especificacao inicial citava Saikuro/MetricFu para complexidade ciclomatica.
Durante a sprint foi identificado que essas ferramentas estao descontinuadas e
apresentaram problemas de compatibilidade. Por isso, a equipe usou os cops de
metricas do RuboCop em uma configuracao isolada (`.rubocop_metrics.yml`) para
extrair os valores de complexidade ciclomatica e ABC Score sem alterar o lint
padrao do projeto.

## Comandos executados

### Metricas iniciais

```bash
bin/rails db:test:prepare
bundle exec rspec
bundle exec cucumber
bundle exec rubycritic app lib --no-browser -f console -f json
bundle exec rubocop --config .rubocop_metrics.yml \
  --only Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity \
  app lib --format simple
bundle exec rdoc app lib --output doc
```

### Metricas finais

Preencher apos a conclusao das refatoracoes e dos testes finais:

```bash
bin/rails db:test:prepare
bundle exec rspec
bundle exec cucumber
bundle exec rubycritic app lib --no-browser -f console -f json
bundle exec rubocop --config .rubocop_metrics.yml \
  --only Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/PerceivedComplexity \
  app lib --format simple
bundle exec rdoc app lib --output doc
```

## Resultados iniciais

Os resultados abaixo foram registrados antes das refatoracoes em
`docs/sprint3-metricas-iniciais.md`.

### Complexidade ciclomatica >= 10

| Metodo | Valor inicial | Arquivo |
|---|---:|---|
| `RespostasController#create` | 15 | `app/controllers/respostas_controller.rb` |
| `TurmaFormulariosController#create` | 11 | `app/controllers/turma_formularios_controller.rb` |
| `TurmaFormulariosController#destroy` | 10 | `app/controllers/turma_formularios_controller.rb` |

*Correcao: o relatorio inicial usava `Max: 10` no RuboCop, que so sinaliza valores
maiores que o Max (nao >=). O metodo `#destroy` com CC exatamente 10 so apareceu
ao reanalizar com `Max: 9`. O arquivo `.rubocop_metrics.yml` foi corrigido.*

### ABC Score >= 20

| Metodo | Valor inicial | Arquivo |
|---|---:|---|
| `RespostasController#create` | 45.71 | `app/controllers/respostas_controller.rb` |
| `SenhaController#salvar` | 39.65 | `app/controllers/senha_controller.rb` |
| `SenhaController#atualizar` | 33.97 | `app/controllers/senha_controller.rb` |
| `Formulario#mensagem_criacao_personalizada` | 31.80 | `app/models/formulario.rb` |
| `LimparDadosService#call` | 29.44 | `app/services/limpar_dados_service.rb` |
| `GerenciamentoController#importar` | 28.11 | `app/controllers/gerenciamento_controller.rb` |
| `TurmaFormulariosController#create` | 23.17 | `app/controllers/turma_formularios_controller.rb` |

### Cobertura inicial

| Metrica | Resultado inicial |
|---|---:|
| Cobertura geral mesclada (RSpec + Cucumber) | 81.02% |
| Linhas cobertas | 508 / 627 |
| RSpec isolado | 45.71% |
| Suite RSpec | 85 exemplos, 0 falhas |
| Suite Cucumber | 117 cenarios, 908 steps, 0 falhas |

### RubyCritic inicial

| Metrica | Resultado inicial |
|---|---:|
| Nota geral do projeto | 91.39 / 100 |
| Arquivo com pior nota | `app/controllers/senha_controller.rb` |
| Arquivo com mais smells | `app/services/importar_dados_service.rb` |
| Documentacao RDoc inicial | 7.06% |

## Comparacao antes/depois da refatoracao

Preencher a coluna final apos a conclusao das Pessoas 2, 3 e 4.

| Item | Antes | Depois | Situacao |
|---|---:|---:|---|
| `RespostasController#create` - complexidade ciclomatica | 15 | Pendente | Aguardando refatoracao |
| `TurmaFormulariosController#create` - complexidade ciclomatica | 11 | Pendente | Aguardando refatoracao |
| `RespostasController#create` - ABC Score | 45.71 | Pendente | Aguardando refatoracao |
| `SenhaController#salvar` - ABC Score | 39.65 | Pendente | Aguardando refatoracao |
| `SenhaController#atualizar` - ABC Score | 33.97 | Pendente | Aguardando refatoracao |
| `Formulario#mensagem_criacao_personalizada` - ABC Score | 31.80 | **Extraido em 3 metodos (maximo < 20)** | Concluido (Pessoa 3) |
| `LimparDadosService#call` - ABC Score | 29.44 | Pendente | Aguardando refatoracao |
| `GerenciamentoController#importar` - ABC Score | 28.11 | Pendente | Aguardando refatoracao |
| `TurmaFormulariosController#create` - ABC Score | 23.17 | Pendente | Aguardando refatoracao |
| Cobertura geral RSpec + Cucumber | 81.02% | Pendente | Aguardando testes finais |
| Nota geral RubyCritic | 91.39 / 100 | Pendente | Aguardando metricas finais |
| Documentacao RDoc | 7.06% | Pendente | Aguardando comentarios finais |

## Refatoracoes realizadas

Preencher quando as alteracoes das Pessoas 2 e 3 forem integradas.

| Arquivo/metodo | Problema inicial | Alteracao realizada | Resultado final |
|---|---|---|---|
| `app/controllers/respostas_controller.rb#create` | CC 15 e ABC 45.71 | Pendente | Pendente |
| `app/controllers/turma_formularios_controller.rb#create` | CC 11 e ABC 23.17 | Pendente | Pendente |
| `app/controllers/senha_controller.rb` | ABC alto e duplicacao | Pendente | Pendente |
| `app/models/formulario.rb` | ABC 31.80 em `mensagem_criacao_personalizada` | Extraido em `validar_ausencia_total`, `validar_campos_obrigatorios` e `formularios_duplicados`; RDoc adicionado em todos os metodos privados | Todos com ABC < 20 e CC < 10 |
| `app/services/limpar_dados_service.rb#call` | ABC 29.44 e 0% cobertura | Pendente | Pendente |
| `app/controllers/gerenciamento_controller.rb#importar` | ABC 28.11 | Pendente | Pendente |
| `app/services/importar_dados_service.rb` | Maior numero de smells | Pendente | Pendente |

## Cobertura de testes

Preencher apos a validacao da Pessoa 4.

| Escopo | Cobertura inicial | Cobertura final | Status |
|---|---:|---:|---|
| Cobertura geral mesclada | 81.02% | Pendente | Pendente |
| Controllers implementados pelo grupo | Pendente | Pendente | Meta: > 90% |
| Models implementados pelo grupo | Pendente | Pendente | Meta: > 90% |

### Suites de teste

| Suite | Resultado inicial | Resultado final |
|---|---|---|
| RSpec | 85 exemplos, 0 falhas | Pendente |
| Cucumber | 117 cenarios, 908 steps, 0 falhas | Pendente |

## Happy path e sad path

As features Cucumber existentes nao devem ser alteradas apenas para acomodar a
refatoracao. A validacao final deve confirmar se os cenarios definidos continuam
passando e se os fluxos principais contem casos felizes e casos de erro.

| Area | Happy path | Sad path | Observacao |
|---|---|---|---|
| Cadastro de usuario | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Login de usuario | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Criacao de formulario | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Templates de formulario | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Responder formulario | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Relatorios | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Gerenciamento por departamento | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Importacao/atualizacao SIGAA | Pendente | Pendente | Aguardando revisao da Pessoa 4 |
| Redefinicao/definicao de senha | Pendente | Pendente | Aguardando revisao da Pessoa 4 |

## Documentacao RDoc

Os metodos criados ou refatorados devem conter comentarios RDoc indicando:

- o que o metodo faz;
- quais argumentos recebe, quando houver;
- o que retorna;
- efeitos colaterais relevantes, como persistencia no banco, envio de email ou
  redirecionamento.

### Checklist RDoc

| Arquivo/metodo | Comentario RDoc conferido? | Observacao |
|---|---|---|
| `app/controllers/respostas_controller.rb#create` | Pendente | Aguardando refatoracao |
| `app/controllers/turma_formularios_controller.rb#create` | Pendente | Aguardando refatoracao |
| `app/controllers/senha_controller.rb` | Pendente | Aguardando refatoracao |
| `app/models/formulario.rb` (validar_ausencia_total, validar_campos_obrigatorios, formularios_duplicados, turma_possui_matricula_ativa, vincular_perguntas_do_template) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/models/usuario.rb` (normalize_email, password_meets_complexity_requirements) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/services/limpar_dados_service.rb#call` | Pendente | Aguardando refatoracao |
| `app/controllers/gerenciamento_controller.rb#importar` | Pendente | Aguardando refatoracao |
| `app/services/importar_dados_service.rb` | Pendente | Aguardando refatoracao |

## Checklist do PR final

- [ ] Branch final da Sprint 3 atualizada com a base correta do projeto.
- [ ] Refatoracoes dos controllers integradas.
- [x] Refatoracoes dos models integradas (Formulario, Usuario).
- [ ] Complexidade ciclomatica final menor que 10 por metodo.
- [ ] ABC Score final menor que 20 por metodo.
- [ ] Cobertura dos controllers/models do grupo maior que 90%.
- [ ] `bundle exec rspec` passando.
- [ ] `bundle exec cucumber` passando.
- [ ] Relatorio RubyCritic final gerado.
- [ ] RDoc gerado ao final.
- [ ] Comentarios RDoc conferidos nos metodos criados/refatorados.
- [ ] Wiki atualizada com tabela antes/depois.
- [ ] PR revisado para evitar alteracoes desnecessarias.

## Pendencias para fechar esta Wiki

1. Receber do João Victor Romero a lista final de controllers refatorados e integrar na branch sprint-3.
2. ~~Receber do João Felipe Stein a lista final de models refatorados.~~ **Concluido.**
3. Receber do Artur os resultados finais de RSpec, Cucumber e SimpleCov.
4. Rodar ou receber o resultado final de RubyCritic, RuboCop Metrics e RDoc (metricas finais).
5. Substituir os campos `Pendente` restantes pelos valores finais apos a integracao de Joao Victor Romero e Artur.
6. Revisar o PR final antes da entrega.
