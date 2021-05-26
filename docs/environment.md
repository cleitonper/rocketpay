# Variáveis de ambiente
Ao ler este guia você será capaz de entender como variáveis de ambiente são usadas neste projeto, e como defini-las através de arquivos `.env` e também através da *linha de comando*.


___
#### Seções da página

  * [Por que usar?](#por-que-usar)
  * [Casos de uso de variáveis de ambiente](#casos-de-uso-de-variáveis-de-ambiente)
    * [Configurações da aplicação](#configurações-da-aplicação)
    * [Configurações do container](#configurações-do-container)
  * [Como definir](#como-definir)
    * [Usando a linha de comando](#usando-a-linha-de-comando)
    * [Usando arquivos .env](#usando-arquivos-env)
  * [Prioridade](#prioridade)
  * [Escopo de arquivos .env](#escopo-de-arquivos-env)
  * [Lista de arquivos .env](#lista-de-arquivos-env)
  * [Lista de variáveis de ambiente](#lista-de-variáveis-de-ambiente)
    * [Banco de dados](#banco-de-dados)
    * [Servidor web](#servidor-web)
    * [Autenticação](#autenticação)
    * [Versões](#versões)
    * [Usuário](#usuário)
    * [Postgres Exporter](#postgres-exporter)
    * [Grafana](#grafana)
  * [Estrutura de diretórios](#estrutura-de-diretórios)

___


## Por que usar?
Algumas informações *sensíveis*, como senha do banco de dados e chaves de criptografia, não devem ser expostas no código fonte, e por isso são obtidas somente quando a aplicação é executada. Uma forma de obter essas informações em tempo de execução é com o uso de variáveis de ambiente.

Um outro motivo para seu uso se dá por conta das informações mudarem de acordo com o *ambiente* em que o projeto é executado. A porta do servidor web pode ter um determinado valor durante o desenvolvimento e mudar quando a aplicação estiver sendo executada em produção. Assim como no caso anterior, esse objetivo também pode ser alcançado usando variáveis de ambiente.


## Casos de uso de variáveis de ambiente
Neste projeto, as variáveis de ambiente são usadas para definir configurações da aplicação em tempo de execução e também algumas caracteristicas do container docker que a executa. A seguir, são listados alguns casos de uso:


### Configurações da aplicação
Aqui são listados alguns casos em que variáveis de ambiente são usadas para definir caracteristicas da aplicação nos arquivos [runtime.exs](../config/runtime.exs) e [session.ex](../lib/rocketpay_web/session.ex).

```elixir
# config/runtime.exs
import Config

# Database
config :rocketpay, Rocketpay.Repo,
  port: System.get_env("DB_PORT", "5432"), # <~ Variável de ambiente DB_PORT
  username: System.get_env("DB_USERNAME"), # <~ Variável de ambiente DB_USERNAME
  password: System.get_env("DB_PASSWORD")  # <~ Variável de ambiente DB_PASSWORD

# Web
config :rocketpay, RocketpayWeb.Endpoint,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE") # <~ Variável de ambiente SECRET_KEY_BASE
  # ...
```

```elixir
# lib/rocketpay_web/session.ex
defmodule RocketpayWeb.Session do
  def options do
    [
      store: :cookie,
      key: "__rocketpay",
      signing_salt: System.get_env("SIGNING_SALT") # <~ Variável de ambiente SIGNING_SALT
    ]
  end
end
```


### Configurações do container
A ferramenta `docker-compose` *carrega* automaticamente variáveis de ambiente definidas a nível do sistema operacional e também aquelas definidas no arquivo `.env` que se encontra na raiz do projeto. Caso a variável não seja encontrada, o valor padrão, definido após o nome da variável seguido dos caracteres `:-`, será usado. Veja abaixo alguns exemplos:

```yml
# docker-compose.yml
services:
  api:
    image: rocketpay:${APP_VERSION:-latest} # <~ Variável de ambiente APP_VERSION
    build:
      args:
        ELIXIR_VERSION: ${ELIXIR_VERSION:-1.11-alpine} # <~ Variável de ambiente ELIXIR_VERSION
        USER: ${USER:-elixir} # <~ Variável de ambiente USER
        GID: ${GID:-1000} # <~ Variável de ambiente GID
        UID: ${UID:-1000} # <~ Variável de ambiente UID
  postgres:
    image: postgres:${POSTGRES_VERSION:-13-alpine} # <~ Variável de ambiente POSTGRES_VERSION
    # ...
```


## Como definir
É possível definir variáveis de ambiente através da linha de comando ou usando arquivos `.env`.


### Usando a linha de comando
Em um terminal `*nix`, use o comando `export` para definir uma variável de ambiente. Veja a seguir como fazer:

```shell
$ export APP_VERSION=1.0.0
$ export POSTGRES_USER=postgres
```


### Usando arquivos .env

Em arquivos `.env`, variáveis de ambiente podem ser armazenadas usando uma estrutura de `chave` e `valor` separadas pelo caracter `=`. Veja um exemplo a seguir:

```shell
# .env
APP_VERSION=1.0.0
POSTGRES_USER=postgres
```


## Prioridade
As variáveis definidas a nível de sistema operacional através do uso da linha de comando tem maior prioridade sobre aquelas definidas em arquivos *.env*. Tendo isso em mente, coso envontre problemas ao executar o projeto, verifique se alguma variável não está definida sem valor a nível do sistema operacional ou em arquivos especificos.


## Escopo de arquivos .env

São quatro os tipos de arquivos `.env` usados neste projeto:

  * `.env` - define variáveis que são usadas no arquivo `docker-compose.yml`
  * `.env.dev` - define variáveis que são usadas pela aplicação no ambiente de desenvolvimento
  * `.env.production` - define variáveis que são usadas pela aplicação no ambiente de produção
  * `.env.example` - arquivo base que serve como exemplo para criação dos demais

**Atenção!** Como mencionado atenriormente, variáveis definidas pelo sistema operacional sempre tem maior prioridade do que aquelas definidas em arquivos *.env*.

**Atenção!** Tome cuidado com o escopo de cada arquivo. O arquivo `.env` não tem qualquer efeito sobre configurações da aplicação, e serve apenas para definir valores no arquivo `docker-compose.yml`. Em contrapartida, os arquivos `.env.dev` e `.env.production` fazem o exto oposto: configuram apenas a aplicação e não tem efeito sobre configrações de *containers*.


## Lista de arquivos .env
Por se tratar de um projeto que executa não só a aplicação mas também ferramentas necessárias para seu funcionamento e monitoramento (como PostgreSQL, Prometheus e Grafana), são usados multiplos arquivos `.env`, organizados em diferentes diretórios. Abaixo são listados os diretórios que devem conter arquivos `.env`:

  * `<raiz>` - na pasta raiz do projeto se encontram os arquivos que definem configurações da aplicação e de containers
  * `<raiz>/docker/postgres` - arquivos usados pelo banco de dados postgres
  * `<raiz>/docker/postgres_exporter` - arquivos usados pela ferramenta [`postgres_exporter`](https://github.com/prometheus-community/postgres_exporter)
  * `<raiz>/docker/grafana` - arquivos usados pela ferramenta grafana


## Lista de variáveis de ambiente
A listagem a seguir enumera as variáveis de ambiente usadas no projeto:

**Atenção!** Note que algumas variáveis de ambiente devem ser preenchidas em mais de um arquivo. Fique atento à coluna **Escopo** e veja se isso é necessário.


### Banco de dados

| Nome              | Descrição                   | Obrigatório  | Escopo              | Padrão   |
| ----------------- | --------------------------- | ------------ | ------------------- | -------- |
| DB_PORT           | Porta de acesso             | Não          | .env.dev            | 5432     |
| DB_HOSTNAME       | Hostname do banco           | Sim          | .env.dev            | -        |
| DB_USERNAME       | Nome de usuário             | Sim          | .env.dev            | -        |
| DB_PASSWORD       | Senha de acesso             | Sim          | .env.dev            | -        |
| DB_POOL_SIZE      | Número de conexões ativas   | Não          | .env.dev            | 10       |
| DB_URL            | Endereço de acesso          | Sim          | .env.production     | -        |
| POSTGRES_PORT     | Porta de acesso             | Não          | docker/postgres/.env.{dev,production}, .env  | 5432     |
| POSTGRES_USER     | Nome de usuário             | Sim          | docker/postgres/.env.{dev,production}, .env  | -        |
| POSTGRES_PASSWORD | Senha de acesso             | Sim          | docker/postgres/.env.{dev,production} | -        |
| POSTGRES_DB       | Nome do banco de dados      | Sim          | docker/postgres/.env.{dev,production} | -        |

**Atenção!** Apesar de terem que ser preenchidas em arquivos diferentes, as variáveis prefixadas com `DB_` e `POSTGRES_` devem possuir o mesmo valor quando se referirem ao mesmo tipo de configuração.


### Servidor web

| Nome            | Descrição                   | Obrigatório  | Escopo                        | Padrão   |
| --------------- | --------------------------- | ------------ | ----------------------------- | -------- |
| SIGNING_SALT    | *Salt* de encriptação       | Sim          | .env.{dev, production}        | -        |
| SECRET_KEY_BASE | Chave de criptografia       | Sim          | .env.{dev, production}        | -        |


### Autenticação

| Nome            | Descrição                      | Obrigatório  | Escopo                    | Padrão   |
| --------------- | ------------------------------ | ------------ | ------------------------- | -------- |
| AUTH_USERNAME   | Usuário de autenticação básica | Sim          | .env.{dev, production}    | -        |
| AUTH_PASSWORD   | Senha de autenticação básica   | Sim          | .env.{dev, production}    | -        |
| AUTH_SECRET     | Chave de criptografia JWT      | Sim          | .env.{dev, production}    | -        |


### Versões

| Nome             | Descrição                                 | Obrigatório  | Escopo     | Padrão       |
| ---------------- | ----------------------------------------- | ------------ | ---------- | ------------ |
| APP_VERSION      | Versão atual da aplicação                 | Não          | .env       | latest       |
| ELIXIR_VERSION   | Versão elixir que executará a aplicação   | Não          | .env       | 1.11-alpine  |
| POSTGRES_VERSION | Versão do banco de dados PostgreSQL       | Não          | .env       | 13-alpine    |


### Usuário

| Nome     | Descrição                            | Obrigatório  | Escopo     | Padrão     |
| -------- | ------------------------------------ | ------------ | ---------- | ---------- |
| USER     | Usuário que executará a aplicação    | Não          | .env       | elixir     |
| GID      | GID do usuário                       | Não          | .env       | 1000       |
| UID      | UID do usuário                       | Não          | .env       | 1000       |


### Postgres Exporter

| Nome              | Descrição                   | Obrigatório  | Escopo                                         | Padrão   |
| ----------------- | --------------------------- | ------------ | ---------------------------------------------- | -------- |
| DATA_SOURCE_USER  | Nome de usuário do banco    | Sim          | docker/postgres_exporter/.env.{dev,production} | -        |
| DATA_SOURCE_PASS  | Senha de acesso do banco    | Sim          | docker/postgres_exporter/.env.{dev,production} | -        |
| DATA_SOURCE_URI   | Endereço de acesso          | Sim          | docker/postgres_exporter/.env.{dev,production} | -        |


### Grafana

| Nome                            | Descrição                            | Obrigatório  | Escopo                                         | Padrão   |
| ------------------------------- | ------------------------------------ | ------------ | ---------------------------------------------- | -------- |
| GF_USERS_ALLOW_SIGN_UP          | Permitir novos cadastros?            | Sim          | docker/postgres_exporter/.env.{dev,production} | -        |
| GF_SECURITY_ADMIN_PASSWORD      | Senha padrão de acesso ao painel     | Sim          | docker/postgres_exporter/.env.{dev,production} | -        |


## Estrutura de diretórios
A estrutura de diretórios representada a seguir lista os locais em que variáveis de ambiente devem ser preenchidas. O arquivo `.env.example` serve como base e contém as variáveis que precisam ser preenchidas em cada diretório. Os demais arquivos devem ser criados e preenchidos de acordo com seu [escopo](#escopo-de-arquivos-env). Para saber mais sobre cada uma delas, veja a [lista de variáveis de ambiente](#lista-de-variáveis-de-ambiente).

```
📦
 ┣ 📂 docker
 ┣ ┯ 📂 grafana
 ┃ ├ 📜 .env.dev
 ┃ ├ 📜 .env.production
 ┃ └ 📜 .env.example
 ┣ ┯ 📂 postgres
 ┃ ├ 📜 .env.dev
 ┃ ├ 📜 .env.production
 ┃ └ 📜 .env.example
 ┣ ┯ 📂 postgres_exporter
 ┃ ├ 📜 .env.dev
 ┃ ├ 📜 .env.production
 ┃ └ 📜 .env.example
 ┣ 📜 .env
 ┣ 📜 .env.dev
 ┣ 📜 .env.production
 ┣ 📜 .env.example
```