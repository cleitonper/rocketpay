![rocketpay logo](priv/static/banner.svg)

# Rocketpay

> Sistema para processamento de transações financeiras

[![Build status](https://img.shields.io/github/workflow/status/cleitonper/rocketpay/Workflow?logo=github-actions&logoColor=white)](https://github.com/cleitonper/rocketpay/actions/workflows/workflow.yml) [![Test coverage](https://img.shields.io/codecov/c/gh/cleitonper/rocketpay?logo=codecov&logoColor=white)](https://codecov.io/gh/cleitonper/rocketpay) [![This project uses Credo](https://img.shields.io/badge/analysis-credo-success?logo=coderwall&logoColor=white)](https://hexdocs.pm/credo/overview.html) [![This project uses Dialyzer](https://img.shields.io/badge/analysis-dialyzer-success?logo=coderwall&logoColor=white)](https://hexdocs.pm/dialyxir/readme.html)


## Pré requisitos
É preciso ter um ambiente de desenvolvimento baseado em _Unix_ (Linux, Mac, WSL, etc) para poder executar esse projeto. Além disso, as ferramentas listadas a seguir precisam ser instaladas:

  * **erlang** - versão `v23.X`
  * **elixir** - versão `v1.11.X-otp-23`
  * **direnv** - para configuração de variáveis de ambiente


## Variáveis de ambiente
Na raiz do projeto, renomeie o arquivo `.env.example` para `.env` e preencha o valor das variáveis de ambiente contidas no arquivo.


## Preparando o ambiente de desenvolvimento
```bash
# Carregue as variáveis de ambiente
$ direnv allow

# Instale as dependencias do projeto
$ mix deps.get

# Gere a estrutura do banco de dados
$ mix ecto.setup
```


## Executando o servidor de desenvolvimento
```bash
# Execute o servidor de desenvolvimento
$ mix phx.server
```


## Testes automatizados
```bash
# Testes automatizados
$ mix test

# Análise estática de código
$ mix credo
$ mix dialyzer
```
