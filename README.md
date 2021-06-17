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
  * [Implantação](#implantação)
  * [Documentação relacionada](#documentação-relacionada)

___


## Pré requisitos
O ambiente de desenvolvimento deste projeto usa *containers* para fornecer a infraestrutura necessária para a execução da aplicação. Por conta disso, é necessário que as ferramentas a seguir sejam instaladas:

  * [`docker`](https://docs.docker.com/get-docker/)
  * [`docker-compose`](https://docs.docker.com/compose/install/)
  * [`buildx`](https://docs.docker.com/buildx/working-with-buildx/#install) (`docker buildx install`)

**Dica!** Caso use o editor **Visual Studio Code**, veja [neste guia](docs/vscode.md) como executar o editor dentro do *container* da aplicação. 


## Variáveis de ambiente
Algumas configurações do projeto são definidas com do uso de variáveis de ambiente, através de arquivos `.env`. Veja como definilas [neste guia](docs/environment.md).


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


## Implantação
A implantação no ambiente de produção é feita de forma automatizada utilizando `workflows` do [Github Actions](https://github.com/features/actions). Para que a uma plantação seja feita, os seguintes critérios devem ser atendidos:

  * Deve ser feito o *push* de um *branch* ou *tag* em um formato especifico.
  * **Branches** devem seguir o formato `release/v*.*.*`. Por exemplo: `release/v1.0.0`.
  * **Tags** devem seguir o formato `v*.*.*`. Por exemplo: `v1.0.0`.
  * Os testes automatizados definidos no *workflow* [Continous Integration](.github/workflows/ci.yml) devem ser executados sem falhas.
  * Atendidos os requisitos acima, a implantação ocorrerá no *workflow* [Continous Delivery](.github/workflows/cd.yml). Caso não ocorra nenhuma falha durante o processo, uma nova versão contendo as mudanças do commit atual será implantada no ambiente configurado.


## Documentação relacionada

  - [Variáveis de Ambiente](docs/environment.md)
  - [Integração do ambiente de desenvolvimento com Visual Studio Code](docs/vscode.md)
  - [Monitorando a aplicação com grafana](docs/monitoring.md)
