![rocketpay logo](priv/static/banner.svg)

# Rocketpay

> Sistema para processamento de transações financeiras


## Pré requisitos
É preciso ter um ambiente de desenvolvimento baseado em _Unix_ (Linux, Mac, WSL, etc) para poder executar esse projeto. Além disso, as ferramentas listadas a seguir precisam ser instaladas:

  * **erlang** - versão `v23.X`
  * **elixir** - versão `v1.11.X-otp-23`
  * **direnv** - para configuração de variáveis de ambiente


## Variáveis de ambiente
Na raiz do projeto, renomeie o arquivo `.envrc.example` para `.envrc` e preencha o valor das variáveis de ambiente contidas no arquivo.


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
