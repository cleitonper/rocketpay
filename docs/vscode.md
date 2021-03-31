# Integração do ambiente de desenvolvimento com Visual Studio Code

O objetivo deste guia é fornecer as ferramentas necessárias para facilitar o desenvolvimento do projeto usando o editor Visual Studio Code.

## Resultado final

[![Remote Containers - Demonstração](https://user-images.githubusercontent.com/13934790/113225575-57104100-9264-11eb-85a8-b2c09006cfe8.gif)](https://user-images.githubusercontent.com/13934790/113072984-9ecc9500-919e-11eb-9300-8a8a5db2ad9a.mp4)

Ao seguir as instruções descritas aqui, seu editor será capaz de:

  * Destacar a sintaxe da linguagem elixir (syntax hilight)
  * Autocompletar instruções e nomes de módulos (autocompletion)
  * Executar ferramentas de análise estática de código (credo e dialyzer) e alertar eventuais problemas no código fonte
  * Executar o editor dentro do container docker da aplicação, permitindo acesso aos comandos `elixir`, `mix`, e `iex`, necessários para o uso das extensões **ElixirLS** e **ElixirLinter**

## Instalação em 5 passos

  * Instale o [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/)
  * Instale a extensão [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls)
  * Instale a extenção [ElixirLinter](https://marketplace.visualstudio.com/items?itemName=iampeterbanjo.elixirlinter)
  * Instale a extenção [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  * Execute a extenção `Remote - Containers`
    * No seu editor, pressione `CTRL` + `SHIFT` + `P`
    * Pesquise por **Remote-Containers: Open Folder In Container** e pressione `ENTER`
    * Selecione a pasta do projeto e aguarde até que o container seja executado
    * Acesse o projeto em http://localhost:4000/api/

___

### Passo 1: Instale o Visual Studio Code Insiders

No momento que esse guia foi escrito, é necessário usar a versão **Insiders** do editor para que seja possível usar a extensão [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers). Siga as instruções do [guia de instalação](https://code.visualstudio.com/insiders/) para instala-lo.

**Dica!** Caso já use o *vscode tradicional* e queira importar suas extensões, temas e configurações para a versão *insiders*, use a extensão [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync).


### Passo 2: Instale a extensão ElixirLS

A extensão [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls) adiciona *syntax highlight*, *autocompletion*, *smart automatic closing of code blocks* e autras funcionalidades que aumentam a produtividade ao escrever código elixir. Faça a instalação seguindo os passos a seguir:

  * No seu editor, pressione `CTRL` + `SHIFT` + `P`
  * Digite `ext install JakeBecker.elixir-ls` e pressione `ENTER`
  * Aguarde a instalação da extensão

**Dica!** Caso tenha problemas ao seguir os passos descritos anteriormente, [instale a extenção manualmente](https://stackoverflow.com/questions/42017617/how-to-install-vs-code-extension-manually#answer-50232194)

**Atensão!** Após abrir o projeto pela primeira vez, a extensção **ElixirLS** irá gerar *PLTS* usados pela ferramenta *Dialyzer*. A criação desses arquivos leva em torno de **15 à 25 minutos**. Aguarde até o editor informar que a geração dos arquivos foi concluída. Caso tenha executado o comando `docker-compose up`, esses arquivos já foram gerados, e não é necessário aguardar.


### Passo 3: Instale a extensão ElixirLinter

A extensão [ElixirLinter](https://marketplace.visualstudio.com/items?itemName=iampeterbanjo.elixirlinter) executa análise estática de código usando a ferramenta [Credo](https://hexdocs.pm/credo/overview.html), de acordo com as definições presentes no arquivo [.credo.exs](../.credo.exs). Adicione a extenção seguindo as orientações a seguir:

  * No seu editor, pressione `CTRL` + `SHIFT` + `P`
  * Digite `ext install iampeterbanjo.elixirlinter` e pressione `ENTER`
  * Aguarde a instalação da extensão

**Dica!** Caso tenha problemas ao seguir os passos descritos anteriormente, [instale a extenção manualmente](https://stackoverflow.com/questions/42017617/how-to-install-vs-code-extension-manually#answer-50232194)


### Passo 4: Instale a extensão Remote Containers

A extensão [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) permite que o Visual Studio Code seja executado dentro de um *container docker*. Siga os passos a seguir para instala-la:

  * No seu editor, pressione `CTRL` + `SHIFT` + `P`
  * Digite `ext install ms-vscode-remote.remote-containers` e pressione `ENTER`
  * Aguarde a instalação da extensão

**Dica!** Caso tenha problemas ao seguir os passos descritos anteriormente, [instale a extenção manualmente](https://stackoverflow.com/questions/42017617/how-to-install-vs-code-extension-manually#answer-50232194)

**Atenção** A extensão **Remote - Containers** funciona apenas na versão **Insiders** do Visual Studio Code. Você provavelmente não conseguirá prosseguir com a instalação caso esteja usando a *versão tradicional* do editor.


### Passo 5: Execute a extenção Remote Containers

Finalizados os passos anteriores, é hora de executar o editor dentro do *container* da aplicação. Em seu editor, siga as instruções abaixo:

  * Pressione `CTRL` + `SHIFT` + `P`
  * Pesquise por **Remote-Containers: Open Folder In Container** e pressione `ENTER`
  * Selecione a pasta do projeto e aguarde até que o container seja executado
  * Acesse o projeto em http://localhost:4000/api/

**Atenção!** Além dos passos 1 à 4 descritos neste guia, é necessário também que o comando `docker-compose build` já tenha sido executado.

**Atenção!** Ao usar a extensão **Remote - Containers**, não é necessário executar o comando `docker-compose up`.