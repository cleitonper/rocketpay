![rocketpay logo](priv/static/banner.svg)

# Rocketpay

> Sistema para processamento de transações financeiras

[![Build status](https://img.shields.io/github/workflow/status/cleitonper/rocketpay/Workflow?logo=github-actions&logoColor=white)](https://github.com/cleitonper/rocketpay/actions/workflows/workflow.yml) [![Test coverage](https://img.shields.io/codecov/c/gh/cleitonper/rocketpay?logo=codecov&logoColor=white)](https://codecov.io/gh/cleitonper/rocketpay) [![This project uses Credo](https://img.shields.io/badge/analysis-credo-success?logo=coderwall&logoColor=white)](https://hexdocs.pm/credo/overview.html) [![This project uses Dialyzer](https://img.shields.io/badge/analysis-dialyzer-success?logo=coderwall&logoColor=white)](https://hexdocs.pm/dialyxir/readme.html)


## Pré requisitos
O ambiente de desenvolvimento deste projeto usa *containers* para fornecer a infraestrutura necessária para a execução da aplicação. Por conta disso, é necessário que as ferramentas a seguir sejam instaladas:

  * [`docker`](https://docs.docker.com/get-docker/)
  * [`docker-compose`](https://docs.docker.com/compose/install/)

**Dica!** Caso use o editor **Visual Studio Code**, veja [neste guia](docs/vscode.md) como executar o editor dentro do *container* da aplicação. 


## Variáveis de ambiente
Na raiz do projeto, renomeie o arquivo `.env.example` para `.env` e preencha o valor das variáveis de ambiente contidas no arquivo.


## Preparando o ambiente de desenvolvimento
Crie a *imagem* que será usada para executar o servidor de desenvolvimento usando o comando abaixo:

```bash
# Crie a imagem que executará o projeto
$ docker-compose build
```


## Executando o servidor de desenvolvimento
Depois de ter criado a *imagem* seguindo o passo anterior, crie e execute o *container* que inicializará nosso servidor de desenvolvimento com o comando a seguir:

```bash
# Execute o servidor de desenvolvimento
$ docker-compose up
```

**Atenção!** Caso tenha seguido o [guia de configuração do editor](docs/vscode.md) *Visual Studio Code*, não é necessário executar o comando acima. Ele é executado automaticamente ao abrir o projeto no editor.


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


## Documentação relacionada

  - [Integração do ambiente de desenvolvimento com Visual Studio Code](docs/vscode.md)
  - [Monitorando a aplicação com grafana](docs/monitoring.md)
