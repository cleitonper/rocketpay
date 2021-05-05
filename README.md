![rocketpay logo](priv/static/banner.svg)

# Rocketpay

> Sistema para processamento de transações financeiras

[![Build status](https://img.shields.io/github/workflow/status/cleitonper/rocketpay/Workflow?logo=github-actions&logoColor=white)](https://github.com/cleitonper/rocketpay/actions/workflows/workflow.yml) [![Test coverage](https://img.shields.io/codecov/c/gh/cleitonper/rocketpay?logo=codecov&logoColor=white)](https://codecov.io/gh/cleitonper/rocketpay) [![This project uses Credo](https://img.shields.io/badge/analysis-credo-success?logo=coderwall&logoColor=white)](https://hexdocs.pm/credo/overview.html) [![This project uses Dialyzer](https://img.shields.io/badge/analysis-dialyzer-success?logo=coderwall&logoColor=white)](https://hexdocs.pm/dialyxir/readme.html)


___
#### Seções da página

  * [Pŕe requisitos](#pré-requisitos)
  * [Variáveis de ambiente](#variáveis-de-ambiente)
  * [Ambiente de desenvolvimento](#ambiente-de-desenvolvimento)
  * [Testes automatizados](#testes-automatizados)
  * [Build de produção](#build-de-produção)
  * [Documentação relacionada](#documentação-relacionada)

___


## Pré requisitos
O ambiente de desenvolvimento deste projeto usa *containers* para fornecer a infraestrutura necessária para a execução da aplicação. Por conta disso, é necessário que as ferramentas a seguir sejam instaladas:

  * [`docker`](https://docs.docker.com/get-docker/)
  * [`docker-compose`](https://docs.docker.com/compose/install/)
  * [`buildx`](https://docs.docker.com/buildx/working-with-buildx/#install) (`docker buildx install`)

**Dica!** Caso use o editor **Visual Studio Code**, veja [neste guia](docs/vscode.md) como executar o editor dentro do *container* da aplicação. 


## Variáveis de ambiente
Na raiz do projeto, renomeie o arquivo `.env.example` para `.env` e preencha o valor das variáveis de ambiente contidas no arquivo.


## Ambiente de desenvolvimento
Sigas as instruções abaixo para executar o servidor de desenvolvimento:

```bash
# Crie a imagem que executará o projeto
$ docker-compose build

# Execute o servidor de desenvolvimento
$ docker-compose up
```

**Atenção!** Caso tenha seguido o [guia de configuração do editor](docs/vscode.md) *Visual Studio Code*, não é necessário executar o comando `docker-compose up`. Ele é executado automaticamente ao abrir o projeto no editor.


## Testes automatizados
Para executar testes automatizados e executar as ferramentas de análise estática de código, use os comandos abaixo:

```bash
# Testes automatizados
$ docker-compose exec api mix test

# Análise estática de código
$ docker-compose exec api mix credo
$ docker-compose exec api mix dialyzer

# ~~~~~~~~~~~~~~> OU <~~~~~~~~~~~~~~~~

# Crie um alias para o comando mix
$ alias mix="docker-compose exec api mix"

# Testes automatizados
$ mix test

# Análise estática de código
$ mix credo
$ mix dialyzer
```

**Atenção!** Para executar os comandos acima, é necessário que o *container* do projeto esteja em execução. Para verificar se o *container* está em execução, use o comando `docker-compose ps`. Um serviço com o nome `api` deve aparecer com o status `Up`.

**Dica!** Para não ter que criar um *alias* toda vez que abrir o projeto, você pode cria-lo no arquivo de configuração do seu shell (`~/.bashrc`, `~/.zshrc`, *etc*).


## Build de produção
Execute os comandos abaixo para gerar um novo [`release`](https://hexdocs.pm/phoenix/releases.html) e executar o ambiente de produção localmente:

```bash
# Crie a imagem que executará conterá os binários de produção
$ docker-compose -f docker-compose.yml build

# Execute a aplicação
$ docker-compose -f docker-compose.yml up
```


## Documentação relacionada

  - [Integração do ambiente de desenvolvimento com Visual Studio Code](docs/vscode.md)
  - [Monitorando a aplicação com grafana](docs/monitoring.md)
