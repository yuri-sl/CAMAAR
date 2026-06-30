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
| João Victor Romero | Refatoracao dos controllers | Concluido |
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
| `RespostasController#create` - complexidade ciclomatica | 15 | **7** | Concluido (João Victor Romero) |
| `TurmaFormulariosController#create` - complexidade ciclomatica | 11 | **3** | Concluido (João Victor Romero) |
| `TurmaFormulariosController#destroy` - complexidade ciclomatica | 10 | **2** | Concluido (João Victor Romero) |
| `RespostasController#create` - ABC Score | 45.71 | **19.05** | Concluido (João Victor Romero) |
| `SenhaController#salvar` - ABC Score | 39.65 | **14.18** | Concluido (João Victor Romero) |
| `SenhaController#atualizar` - ABC Score | 33.97 | **17.92** | Concluido (João Victor Romero) |
| `Formulario#mensagem_criacao_personalizada` - ABC Score | 31.80 | **Extraido em 3 metodos (maximo < 20)** | Concluido (João Felipe Stein) |
| `LimparDadosService#call` - ABC Score | 29.44 | Pendente | Fora do escopo de controllers/models — service ainda nao refatorado |
| `GerenciamentoController#importar` - ABC Score | 28.11 | **10.63** | Concluido (João Victor Romero) |
| `TurmaFormulariosController#create` - ABC Score | 23.17 | **10.63** | Concluido (João Victor Romero) |
| Cobertura geral RSpec + Cucumber | 81.02% | 73.45% (intermediario) | Aguardando trabalho de cobertura do Artur |
| Nota geral RubyCritic | 91.39 / 100 | 90.96 / 100 (intermediario) | Aguardando metricas finais (services ainda pendentes) |
| Documentacao RDoc | 7.06% | Pendente | Aguardando comentarios finais |

*Nota sobre a cobertura intermediaria (73.45%, abaixo do 81.02% inicial): extrair metodos
privados aumenta o numero de linhas relevantes para o SimpleCov sem que os testes existentes
necessariamente cubram todos os novos caminhos (ex.: guards de erro pouco exercitados). Isso e
esperado nesta fase e deve ser corrigido pelo trabalho de cobertura do Artur (Pessoa 4), nao por
uma regressao na refatoracao — toda a suite de RSpec/Cucumber continua passando (85 + 117).*

## Refatoracoes realizadas

Preencher quando as alteracoes das Pessoas 2 e 3 forem integradas.

| Arquivo/metodo | Problema inicial | Alteracao realizada | Resultado final |
|---|---|---|---|
| `app/controllers/respostas_controller.rb#create` | CC 15 e ABC 45.71 | Extraido em `find_formulario`, `find_estudante`, `estudante_tem_permissao?`, `resposta_unica?`, `respostas_preenchidas?`; RDoc completo | CC 7 e ABC 19.05 |
| `app/controllers/turma_formularios_controller.rb` (`create` e `destroy`) | CC 11/10 e ABC 23.17/18.79 | Extraido em `find_turma_and_authorize`, `find_formulario_and_authorize`, `turma_pertence_ao_departamento?`, `turmas_do_departamento_ids`; RDoc completo | `create`: CC 3 / ABC 10.63. `destroy`: CC 2 / ABC 6.4 |
| `app/controllers/senha_controller.rb` (`atualizar` e `salvar`) | ABC 33.97/39.65 e duplicacao da logica de erro | Extraido em `senha_antiga_correta?`, `senhas_iguais?`, `aplicar_nova_senha`, `find_usuario_by_token_or_redirect`, `password_present?`, `passwords_match?`, `new_password_different?`, `primeira_mensagem_de_erro`; RDoc completo | `atualizar`: ABC 17.92. `salvar`: ABC 14.18 |
| `app/models/formulario.rb` | ABC 31.80 em `mensagem_criacao_personalizada` | Extraido em `validar_ausencia_total`, `validar_campos_obrigatorios` e `formularios_duplicados`; RDoc adicionado em todos os metodos privados | Todos com ABC < 20 e CC < 10 |
| `app/services/limpar_dados_service.rb#call` | ABC 29.44 e 0% cobertura | Pendente | Pendente |
| `app/controllers/gerenciamento_controller.rb#importar` | ABC 28.11 | Extraido em `arquivos_presentes?`, `redirecionar_arquivos_ausentes`, `processar_importacao`; RDoc completo | ABC 10.63 |
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
| `app/controllers/respostas_controller.rb` (find_formulario, find_estudante, estudante_tem_permissao?, resposta_unica?, respostas_preenchidas?) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/controllers/turma_formularios_controller.rb` (find_turma_and_authorize, find_formulario_and_authorize, turma_pertence_ao_departamento?, turmas_do_departamento_ids) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/controllers/senha_controller.rb` (senha_antiga_correta?, senhas_iguais?, aplicar_nova_senha, find_usuario_by_token_or_redirect, password_present?, passwords_match?, new_password_different?, primeira_mensagem_de_erro) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/models/formulario.rb` (validar_ausencia_total, validar_campos_obrigatorios, formularios_duplicados, turma_possui_matricula_ativa, vincular_perguntas_do_template) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/models/usuario.rb` (normalize_email, password_meets_complexity_requirements) | Sim | Formato: descricao, argumentos, retorno e efeitos colaterais |
| `app/services/limpar_dados_service.rb#call` | Pendente | Aguardando refatoracao |
| `app/controllers/gerenciamento_controller.rb` (arquivos_presentes?, redirecionar_arquivos_ausentes, processar_importacao) | Sim | Formato: descricao, parametros, retorno e efeitos colaterais |
| `app/services/importar_dados_service.rb` | Pendente | Aguardando refatoracao |

## Checklist do PR final

- [ ] Branch final da Sprint 3 atualizada com a base correta do projeto.
- [x] Refatoracoes dos controllers integradas (RespostasController, TurmaFormulariosController, SenhaController, GerenciamentoController) — branch `sprint-3-refatoracao-documentacao-rework`, aguardando merge em `sprint-3`.
- [x] Refatoracoes dos models integradas (Formulario, Usuario).
- [ ] Complexidade ciclomatica final menor que 10 por metodo (controllers e models: ok; falta `LimparDadosService#call`).
- [ ] ABC Score final menor que 20 por metodo (controllers e models: ok; falta `LimparDadosService#call`).
- [ ] Cobertura dos controllers/models do grupo maior que 90%.
- [x] `bundle exec rspec` passando (85 exemplos, 0 falhas).
- [x] `bundle exec cucumber` passando (117 cenarios, 908 steps, 0 falhas).
- [ ] Relatorio RubyCritic final gerado (gerado intermediario: 90.96/100; falta services).
- [ ] RDoc gerado ao final.
- [ ] Comentarios RDoc conferidos nos metodos criados/refatorados (controllers e models: ok; falta services).
- [ ] Wiki atualizada com tabela antes/depois.
- [ ] PR revisado para evitar alteracoes desnecessarias.

## Pendencias para fechar esta Wiki

1. ~~Receber do João Victor Romero a lista final de controllers refatorados.~~ **Concluido.** Falta apenas o merge da branch `sprint-3-refatoracao-documentacao-rework` em `sprint-3`.
2. ~~Receber do João Felipe Stein a lista final de models refatorados.~~ **Concluido.**
3. Receber do Artur os resultados finais de RSpec, Cucumber e SimpleCov (cobertura > 90% por controller/model).
4. Refatorar `app/services/limpar_dados_service.rb#call` (ABC 29.44) e revisar smells de `app/services/importar_dados_service.rb` — unico ponto fora de controllers/models ainda pendente.
5. Rodar o resultado final de RubyCritic, RuboCop Metrics e RDoc apos a integracao de todas as branches.
6. Substituir os campos `Pendente` restantes pelos valores finais apos a integracao de Joao Victor Romero e Artur.
7. Revisar o PR final antes da entrega.
