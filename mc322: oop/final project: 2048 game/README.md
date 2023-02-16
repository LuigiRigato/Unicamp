# Jogo 2048
Nos inspiramos no jogo 2048 pois acreditamos que ele teria o potencial para desenvolvermos um jogo que é inteligível em sua jogabilidade, mas que ofereceria diversos desafios para que fosse desenvolvido.

O jogo é formado por um tabuleiro, onde blocos são gerados em posições aleatórias a cada rodada. O papel do jogador é juntar blocos de números iguais e conseguir alcançar o bloco de número 2048, sem deixar o tabuleiro ser completamente preenchido.

Na nossa versão do jogo foram criados blocos especiais, que podem ser selecionados previamente e que servem para dinamizar ainda mais a gameplay, oferecendo desafios adicionais para o jogador. Também é possível selecionar o tamanho do tabuleiro desejado, para que o jogador possa customizar o jogo à sua preferência.



## Equipe
* `Luigi Mello Rigato` - `247248`
* `Raphael Ferezin Kitahara` - `244839`

## Arquivo Executável do Jogo
> [arquivo github](2048.jar)
>
> [google drive](https://drive.google.com/file/d/1i9GrHzZoogG3aWtwO08b4Cybgek3g0Mo/view?usp=sharing)

## Slides do projeto

### Slides da prévia
> [slides da prévia](https://www.canva.com/design/DAFBkFfnESE/NaXgOqQKhrpLeGiPTONJdQ/view?utm_content=DAFBkFfnESE&utm_campaign=designshare&utm_medium=link&utm_source=homepage_design_menu)

### Slides da Apresentação Final
> [slides da apresentação final](https://www.canva.com/design/DAFE2QOQieI/DgoEiCKvg8lAzDl2039lpw/view?utm_content=DAFE2QOQieI&utm_campaign=designshare&utm_medium=link&utm_source=homepage_design_menu)

### Relatório de Evolução
A ideia do jogo começou com a gente procurando no celular um jogo que conhecessemos bem, enxergássemos viabilidade de programá-lo e gostássemos bastante, de modo que o esforço do trabalho fosse um divertimento a cada conquista e não um sacrifício a cada bug. Então achamos o 2048! A estrutura que imediatamente pensamos para o jogo original era simples, já que não havia blocos especiais, apenas numéricos que dobravam até chegar em 2048. Haveria apenas uma interface IBlocos, uma classe Tabuleiro, uma Blocos, uma Controle, uma Montador e as classes relacionadas ao framework. Para a escolha deste, ouvimos os nossos amigos falando sobre o [LibGDX](https://libgdx.com/), ótimo e completo para desenvolvimento em Java com um tutorial de qualidade no próprio site. Até aí, o projeto parecia simples e começou bem, até que terminamos em menos de um dia as 4 principais classes do programa. Faltava algo; bugs, dificuldades, madrugadas viradas com café e lágrimas NÃO ESTAVAM APARECENDO e estávamos frustados com isso, porque é isso que queremos como programadores: bugs para resolver e debugar para que a vitória venha sofrida!

Até que começamos a planejar os blocos especiais e cada ideia maluca de funcionalidade nova vinha atrelada a uma nova classe, novas interfaces e relação com design pattterns! Alguns blocos especiais, como o Deleta e o Dobro, foram mais tranquilos, pois já se enquadravam à estrutura do jogo. Outros blocos, como o Bomba e o Tempo, tomaram sozinhos 60% do esforço do trabalho inteiro e 90% dos bugs impossíveis, pois antes não era necessário monitorar as vidas e as coordenadas de cada bloco. Também encontramos outra barreira gigante que foi a implementação da interface gráfica e de animações, já que não tínhamos experiência prévia nenhuma trabalhando com isso.

Depois de muitas pesquisas, noites viradas e *várias* chamadas que duraram horas finalmente conseguimos ajeitar tudo e fazer o jogo funcionar como queríamos! Bem, ainda pode melhorar bastante, como discutiremos mais adiante, mas foi incrívelmente recompensador ver um projeto com um escopo maior como esse ir se moldando até ser entregue. Agradecemos imensamente à equipe da disciplina pela oportunidade e esperamos que vocês gostem do jogo tanto quando nós! ;)


## Destaques de Código

### ATENÇÃO: nos diagramas, as setas e algumas minúcias importantes são pretas e são pouco visíveis com o Modo Escuro do GitHub. Para acionar o Modo Claro (extremamente recomendado), clique na sua foto de perfil no canto superior direiro da tela, depois Settings -> Appearance -> Day Theme.

### Movimentação
É a função que realiza as movimentações no jogo. Tem uma seção inicial que é responsável pelas animações e alterações gráficas e, depois, segue para uma sequência de condições para cada tipo de movimentação possível. Destaca-se, também, o uso de recursão entre funções responsáveis pela movimentação, como no primeiro caso, explicitado abaixo.

```java
private void movimenta(char direcao, int linhaIni, int colunaIni, SpriteBatch batch, Stage stage)
{
	// animação - parte que define as posições em que as imagens devem ser posicionadas e cria uma sequência para a animação dos blocos
	...

	// quando está vazio na frente, livre para continuar se movendo
	if(Objects.equals(board.getId(linhaFim, colunaFim), 0))
	{
		// nesse caso, pegamos o bloco da posição inicial e o transferimos para a posição final, já que ela era vazia e comocamos um bloco vazio na posição inicial
		board.setBloco(linhaFim, colunaFim, board.getBloco(linhaIni, colunaIni));
		board.getBloco(linhaIni, colunaIni).getImagem().addAction(animaBloco); // responsável por animar a transição
		board.setBloco(linhaIni, colunaIni, new BlocoGenerico(0));
		// há o uso de recursão através do chamado da função interpretaComando, que chamará, novamente, a função movimenta, até que o bloco encontre outro ou a parede do tabuleiro
		interpretaComando(direcao, linhaFim, colunaFim, batch, stage);

		algoMudou = true; 
		// variável que serve de controle para, caso não haja nenhum movimento quando o jogador fizer uma jogada, não serem spawnados novos blocos
	}

	// quando ambos os blocos são iguais e podem se juntar
	else if(Objects.equals(board.getId(linhaFim, colunaFim), board.getId(linhaIni, colunaIni)))
	{
		board.getBloco(linhaFim, colunaFim).getImagem().addAction(Actions.removeActor()); // removendo a imagem do bloco de destino (já que ele vai ser substituido por seu dobro)
		if(board.getBloco(linhaFim, colunaFim) instanceof BlocoGenerico)
		{
			((BlocoGenerico) board.getBloco(linhaFim, colunaFim)).dobra(); // método que dobra o número do bloco
		}
		board.getBloco(linhaIni, colunaIni).getImagem().addAction(animaBloco);
		board.setBloco(linhaIni, colunaIni, new BlocoGenerico(0));
		board.getBloco(linhaFim, colunaFim).setJuntado(true);
		algoMudou = true;
	}
	...
}
```

### Uso de Object
Para cada bloco foi designado um id específico, que o caracterizaria e permitiria que realizássemos ações relacionadas a ele (ex: juntar dois blocos de número 4, que teriam o mesmo id = 4).
No início, quando tínhamos apenas blocos numéricos, o id era definido como int, mas, ao adicionarmos os blocos especiais, observamos que não seria intuitivo designarmos um número genérico para os blocos bomba, deleta e tempo.
A solução foi implementarmos o id como um Object, fazendo com que pudéssemos continuar usando os inteiros com ids, para os blocos numéricos, e, também, implementar Strings que identificassem cada bloco especial.

```java
public Object getId(); // cada bloco tem o seu ID, algo que o identifique, podendo ser uma String, int, ...
```


## Destaques de Orientação a Objetos
### Herança de interfaces
No projeto, a herança de interfaces foi largamente utilizada para a definição das interfaces dos blocos, já que cada classe de blocos teria que implementar métodos gerais a todos os blocos e alguns específicos às suas características.

![Diagrama heranca de interfaces](diagramas/diagrama-heranca-de-interfaces.png)

```java
// interface geral a todos os blocos
public interface IBlocos
{
    ...
}

// interface que se refere aos blocos timer e bomba (que possuem "vida" que diminui até sumirem ou explodirem
public interface IBlocosVidas extends IBlocos
{
	...
}

// interfaces referentes a cada um dos blocos que possuem "vida", que foram criadas para que pudéssemos obter instâncias de cada um deles de maneira separada
public interface IBombControl extends IBlocosVidas
{}
public interface ITimerControl extends IBlocosVidas
{}
```

### Interfaces
Foram criadas algumas interfaces mais específicas para que pudéssemos implementar um filtro de visão de outras classes em relação ao controle. Isso fica evidente, por exemplo, na interface IGameScreenControl, que filtra os métodos do Controle que a TelaJogo pode acessar.
Além das classes de telas, também utilizamos esse método de criação de interfaces para as conexões entre as classes Tabuleiro e Controle e entre o Controle e o Criador.

![Diagrama interfaces destaques](diagramas/diagrama-interfaces-destaques.png)

```java
// exemplos de interfaces para telas
public interface IGameScreenControl
{
    ...
}

public interface ISettingScreenControl
{
    ...
}


// exemplo de interface que realiza o filtro entre Controle e Tabuleiro
public interface IBoardControl
{
    ...
}
```

### Classe abstrata
Criamos uma classe abstrata TelaAbstrata, que seria herdada por todas as outras telas do jogo. Dessa forma, seria possível definirmos os métodos requeridos pela interface Screen do LibGDX apenas uma vez e não teríamos que fazer um método render( ) diferente para cada uma das telas, por exemplo. Não tivemos tempo de finalizarmos toda essa estruturação, pois cada tela tinha suas especificidades de input e de visualização, mas esse seria um dos principais ajustes a serem feitos futuramente, para que as classes do View ficassem ainda melhor estruturadas.

![Diagrama classe abstrata](diagramas/diagrama-classe-abstrata.png)

```java
public abstract class TelaAbstrata extends Stage implements Screen
{
    protected TelaAbstrata()
    {
        super(new StretchViewport(400f, 400f, new OrthographicCamera()));
    }
    
    @Override
    public void render(float delta)
    {
        // limpar tela
        Gdx.gl.glClearColor(0.32f, 0.41f, 0.42f, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);

        // métodos do stage
        super.act(delta);
        super.draw();
    }
    
    @Override
    public void resize(int width, int height)
    {
        getViewport().update(width, height, true);
    }
	  ...
}
```
## Destaques de Pattern
### Facade
Implementamos, na classe Criador, o método create( ), que se caracteriza como um facade, já que reúne diversas outras funções, próprias do LibGDX, em um bloco único, que age como uma “caixa preta” para a criação dos elementos visuais.

![Diagrama facade](diagramas/diagrama-facade.png)

```java
public void create()
{
    // criação da câmera, do batch e do stage
    camera = new OrthographicCamera();
    camera.setToOrtho(false, 500, 500);
    batch = new SpriteBatch();
    stage = new Stage(new StretchViewport(camera.viewportWidth, camera.viewportHeight));
    Gdx.input.setInputProcessor(stage);

    // criação do controle
    controle = new Controle(this);

    // fazendo o load da música de fundo e a iniciando
    music = Gdx.audio.newMusic(Gdx.files.internal("musicas/Corona-320bit.mp3"));
    music.setLooping(true);
    music.play();
 
    // definindo a tela como tela inicial
    this.setScreen(new TelaInicial(this));
}
```

### Singleton
Quando fomos testando algumas vezes, percebemos que tanto o Bloco Tempo quanto o Bloco Bomba inviabilizavam o jogo quando começavam a aparecer vários. Portanto, pensamos que limitaríamos a sua quantidade a um Bloco Bomba e um Bloco Tempo por vez de cada no tabuleiro e logo lembramos que o Singleton poderia ser útil nesse caso, já que proibe a criação de múltiplas instâncias do mesmo bloco.

![Diagrama singleton](diagramas/diagrama-singleton.png)

```java
public class BlocoBomba implements IBombControl
{
    private static IBombControl instance;
    ...

    // para implementar o design pattern singleton, é necessário um construtor privado
    private BlocoBomba()
    {}
    
    // implementação do design pattern singleton, garantindo que só uma instância de bomba exista
    public static IBombControl getInstance()
    {
        if (instance == null)
        {
            instance = new BlocoBomba();
        }
        return instance;
    }
    ...
}

public class BlocoTempo implements ITimerControl
{
    private static ITimerControl instance;
    ...

    // para implementar o design pattern singleton, é necessário um construtor privado
    private BlocoTempo()
    {}
    
    // implementação do design pattern singleton, garantindo que só uma instância de bloco tempo exista
    public static ITimerControl getInstance()
    {
        if (instance == null)
        {
            instance = new BlocoTempo();
        }

        return instance;
    }
    ...
}
```

## Conclusões e Trabalhos Futuros
Consideramos que o projeto foi bem sucedido, pois foi possível implementar as funcionalidades que achávamos essenciais ao jogo e acreditamos que conseguimos estruturar o projeto bem.

A curva de aprendizado foi gigante, já que nunca havíamos implementado interface gráfica em nenhum programa e também nunca havíamos colaborado com outras pessoas em projetos mais complexos, como este.

Como mencionado, não tínhamos experiência prévia com interface gráfica, mas desejávamos fazer uma que tivesse uma boa qualidade, já que ela tem uma grande influência na jogabilidade e na experiência de usuário, então utilizamos o framework libGDX para que tivéssemos um bom escopo para implementarmos o que tínhamos em mente. As animações foram a parte mais difícil do processo e estavam demandando tempo demais, enquanto ainda não tínhamos resolvido todos os bugs da lógica do jogo em si, então uma das principais melhorias, relacionadas à interface gráfica, seria animar melhor os blocos especiais (colocar animações melhores para as explosões e para o bloco tempo quando some) e melhorar as animações quando os blocos se movimentam sem se juntar.

Seria adequado, também, como já mencionado no destaque da classe abstrata, compartimentar melhor as estruturas de cada tela e generalizá-las para que o uso da TelaAbstrata se torne mais eficiente.

Com relação ao jogo em si, poderiam ser criados, no futuro, novos blocos especiais, blocos  numéricos que vão além de 2048 (4096, 8192, …) para caso o jogador, ao chegar em 2048, tabuleiros de diversos formatos (losangos, retângulos, triângulos...) desejasse continuar jogando e, queríamos, por fim, ter implementado um sistema de pontuação, que seria acompanhado de um ranking de jogadores.




## Diagramas

### Diagrama Geral da Arquitetura do Jogo
> [diagrama.pdf](diagramas/diagrama.pdf)
> Para melhor qualidade do diagrama, faça o seu download.

O diagrama acima está dividido em três seções que englobam o modelo MVC. Estão presentes todas as estruturas, classes e interfaces implementadas no jogo. Foram apenas omitidos os design patterns e os componentes, já que o detalhamento destes é feito neste arquivo, com diagramas individuais para cada um deles.


### Diagrama Geral de Componentes
![Diagrama geral componentes](diagramas/diagrama-geral-componentes.png)

O diagrama mostra os componentes principais do jogo e como cada um se interliga para transmitir as informações durante o jogo e as interfaces que os relacionam.

### Componente `Criador`
Esse componente serve como principal montador do jogo, sendo responsável por criar principais estruturas da lógica e da interface visual para repassá-las ao Controle e às telas para serem apresentadas.

![Componente](diagramas/diagrama-criador.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/Criador.java](2048/core/src/com/poo/game2048/Criador.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `ICreatorControl e IsettingScreenCreator`

### Componente `Controle`
Esse componente serve como principal articulador do jogo, sendo responsável por manipular as principais estruturas da montagem do jogo, da lógica, da interface visual e dos blocos, para repassá-las e às telas para serem apresentadas.

![Componente](diagramas/diagrama-controle.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/Controle.java](2048/core/src/com/poo/game2048/Controle.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `ICreatorControl, IGameScreenControl, IBoardControl e IsettingScreenControl`

### Componente `Tabuleiro`
Esse componente serve como base de suporte para o Model, sendo que todos os blocos serão acessados por uma matriz que é atributo do Tabuleiro. Assim, ele coordenará a comunicação entre os blocos e o externo, ou seja, com o Controle.

![Componente](diagramas/diagrama-tabuleiro.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/Tabuleiro.java](2048/core/src/com/poo/game2048/Tabuleiro.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IBoardControl, IBlocos`

### Componente `TelaConfigurações`
Essa é a tela em que o jogador escolhe o tamanho do tabuleiro a ser criado (comunicação com o Criador) e quais blocos especiais participarão das rodadas (comunicação com o Controle). Ademais, essa tela é apresentada pela interface gráfica, então precisa de uma interface Screen própria do LibGDX.

![Componente](diagramas/diagrama-telaconfiguracoes.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/Telas/TelaConfiguracoes.java](2048/core/src/com/poo/game2048/Telas/TelaConfiguracoes.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `ISettingScreenControl, Screen e ISettingScreenCreator`

### Componente `TelaJogo`
Essa é a tela em que o jogador efetivamente jogará, requerindo uma comunicação com o Controle. Ademais, essa tela é apresentada pela interface gráfica, então precisa de uma interface Screen própria do LibGDX.

![Componente](diagramas/diagrama-telajogo.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/Telas/TelaJogo.java](2048/core/src/com/poo/game2048/Telas/TelaJogo.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IGameScreenControl e Screen`

### Componente `BlocoDobro`
Esse é referente ao Bloco Dobro, o qual pode ser acessado através do Tabuleiro.

![Componente](diagramas/diagrama-blocodobro.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/PastaBlocos/BlocoDobro.java](2048/core/src/com/poo/game2048/PastaBlocos/BlocoDobro.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IBlocos`

### Componente `BlocoDeleta`
Esse é referente ao Bloco Deleta, o qual pode ser acessado através do Tabuleiro.

![Componente](diagramas/diagrama-blocodeleta.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/PastaBlocos/BlocoDeleta.java](2048/core/src/com/poo/game2048/PastaBlocos/BlocoDeleta.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IBlocos`

### Componente `BlocoGenérico`
Esse é referente aos Blocos Genéricos, ou seja, os blocos numéricos, os quais podem ser acessados através do Tabuleiro.

![Componente](diagramas/diagrama-blocogenerico.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/PastaBlocos/BlocoGenerico.java](2048/core/src/com/poo/game2048/PastaBlocos/BlocoGenerico.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IBlocos`

### Componente `BlocoBomba`
Esse é referente ao Bloco Bomba, o qual pode ser acessado através do Tabuleiro, mas também é dado o seu acesso ao Controle, já que ele pode explodir e afetar a dinâmica de outros blocos e outras movimentações.

![Componente](diagramas/diagrama-blocobomba.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/PastaBlocos/BlocoBomba.java](2048/core/src/com/poo/game2048/PastaBlocos/BlocoBomba.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IBlocos e IBombControl`

### Componente `BlocoTempo`
Esse é referente ao Bloco Tempo, o qual pode ser acessado através do Tabuleiro, mas também é dado o seu acesso ao Controle, já que ele pode atrapalhar e afetar a dinâmica de outros blocos e outras movimentações.

![Componente](diagramas/diagrama-blocotempo.png)

**Ficha Técnica**
item | detalhamento
----- | -----
Classe | [2048/core/src/com/poo/game2048/PastaBlocos/BlocoTempo.java](2048/core/src/com/poo/game2048/PastaBlocos/BlocoTempo.java)
Autores | `Luigi Rigato e Raphael Kitahara`
Interfaces | `IBlocos e ITimerControl`

## Detalhamento das Interfaces

#### Interface `IBlocos`
Interface implementada por todas as classes de blocos, que define os métodos essenciais a elas.

```java
public interface IBlocos
{
    public Object getId(); // cada bloco tem o seu ID, algo que o identifique, podendo ser uma String, int, ...
    public Image getImagem();
    public boolean getJuntado();
    public void setJuntado(boolean info);
    public float getPosX();
    public void setPosX(float posX);
    public float getPosY();
    public void setPosY(float posY);
    public float getSize();
    public void setSize(float size);
}
```

Método | Objetivo
-------| --------
`getId` | Retorna o id do bloco.
`getImage` | Retorna a imagem do bloco (necessária para ser posicionada na tela).
`getJuntado` | Retorna se o bloco já foi juntado com outro durante a rodada, para que os blocos não se juntem infinitamente.
`setJuntado` | Define se o bloco já foi juntado ou não através do parâmetro `info`.
`getPosX` | Retorna a posição X em que o bloco está localizado na tela (em relação à interface gráfica).
`setPosX` | Define a posição X em que o bloco está localizado na tela (em relação à interface gráfica) através do parâmetro `posX`.
`getPosY` | Retorna a posição Y em que o bloco está localizado na tela (em relação à interface gráfica).
`setPosY` | Define a posição Y em que o bloco está localizado na tela (em relação à interface gráfica) através do parâmetro `posY`.
`getSize` | Retorna o tamanho do bloco na tela (em relação à interface gráfica).
`setSize` | Define o tamanho do bloco na tela (em relação à interface gráfica) através do parâmetro `size`.


#### Interface `IBlocosVidas`
Interface implementada por todas as classes de blocos que possuem "vida" (blocos bomba e tempo), ou seja, que ficam temporariamente no tabuleiro, definindo todos os métodos essenciais a elas.

```java
public interface IBlocosVidas extends IBlocos
{
    public void setImagem(Image imagem);
    public int getVida();
    public void setVida(int mudanca);
    public boolean getAtivo();
    public void setAtivo(boolean info);
    public int getLinha();
    public void setLinha(int linha);
    public int getColuna();
    public void setColuna(int coluna);
    public void reset();
}
```

Método | Objetivo
-------| --------
`setImage` | Define a imagem do bloco (necessária para ser posicionada na tela) através do parâmetro `imagem`.
`getVida` | Retorna a vida atual do bloco.
`setVida` | Adiciona `mudanca` à vida atual do bloco.
`getAtivo` | Retorna `true` caso o bloco em questão esteja no tabuleiro e `false` caso não haja nenhum bloco ativo. É importante, pois precisamos saber se há um bloco no tabuleiro e se ele deve perder uma vida a cada rodada.
`setAtivo` | Define `true` caso o bloco em questão esteja no tabuleiro e `false` caso não haja nenhum bloco ativo através do parâmetro `info`.
`getLinha` | Retorna a linha do tabuleiro em que o bloco está posicionado. É importante rastrearmos a posição do bloco bomba para explodirmos os blocos ao seu redor.
`setLinha` | Define a linha do tabuleiro em que o bloco está posicionado através do parâmetro `linha`.
`getColuna` | Retorna a coluna do tabuleiro em que o bloco está posicionado.
`setColuna` | Define a coluna do tabuleiro em que o bloco está posicionado através do parâmetro `coluna`.
`reset` | Redefine as vidas do bloco, define que ele não está no tabuleiro e define a sua imagem inicial.


#### Interface `IBombControl`
Interface implementada pela classe `BlocoBomba`, utilizada para que o controle poss obter instâncias do bloco bomba separadamente do bloco tempo. A intenção inicial era de definir métodos que apenas o bomba teria, mas o bloco tempo acabou por precisar dos mesmos métodos do bloco bomba, então decidimos colocar todos os métodos na interface `IBlocosVidas`, herdada pelas interfaces `IBombControl` e `ITimerControl`, que foram implementadas para fins de melhor organização do código.

```java
public interface IBombControl extends IBlocosVidas
{}
```


#### Interface `ITimerControl`
Interface implementada pela classe `BlocoTempo`, utilizada para que o controle possa obter instâncias do bloco tempo separadamente do bloco bomba.

```java
public interface ITimerControl extends IBlocosVidas
{}
```


#### Interface `IBoardControl`
Interface que serve como um "filtro de visão" dos métodos do tabuleiro para o controle.

```java
public interface IBoardControl
{
    public int getTamanho();
    public Object getId(int linha, int coluna);
    public IBlocos getBloco(int linha, int coluna);
    public void setBloco(int linha, int coluna, IBlocos bloco);
}
```

Método | Objetivo
-------| --------
`getTamanho` | Retorna o tamanho do tabuleiro.
`getId` | Retorna o id de um bloco posicionado na `linha` e na `coluna` indicadas.
`getBloco` | Retorna o bloco posicionado na `linha` e na `coluna` indicadas.
`setBloco` | Define o bloco posicionado na `linha` e na `coluna` indicadas através do parâmetro `bloco` passado.


#### Interface `ICreatorControl`
Interface que serve como um "filtro de visão" dos métodos do criador para o controle.

```java
public interface ICreatorControl
{
    public Controle getControle();
    public SpriteBatch getBatch();
    public Stage getStage();
    public void setTamanhoTabuleiro(int tamanhoTabuleiro);
    public void setScreen(Screen screen);
}
```

Método | Objetivo
-------| --------
`getControle` | Retorna a instância do controle do jogo.
`getBatch` | Retorna o batch do jogo (relacionado à interface visual).
`getStage` | Retorna o stage do jogo (relacionado à interface visual).
`setTamanhoTabuleiro` | Define o tamanho do tabuleiro através do parâmetro `tamanhoTabuleiro`.
`setScreen` | Define a tela do jogo a ser exibida, através do parâmetro `screen`.


#### Interface `IGameScreenControl`
Interface que serve como um "filtro de visão" dos métodos do controle para a tela jogo.

```java
public interface IGameScreenControl
{
    public void conectaTabuleiro(Tabuleiro tabuleiro);
    public void spawnBloco();
    public void transfereComando(char direcao);
	public boolean getGanhou();
    public void setGanhou(boolean b);
}
```

Método | Objetivo
-------| --------
`conectaTabuleiro` | Realiza a conexão da instância do tabuleiro para ser utilizado no controle.
`spawnBloco` | Adiciona um bloco (entre os possíveis) em uma posição vazia aleatória do tabuleiro.
`transfereComando` | Transfere a direção de uma movimentação feita pelo jogador para o controle através do parâmetro `direção`.
`getGanhou` | Retorna `true` caso o jogador tenha ganhado e `false` em caso contrário (o jogo continua).
`setGanhou` | Define `true` caso o jogador tenha ganhado e `false` em caso contrário (o jogo continua) através do parâmetro `b` (boolean).


#### Interface `ISettingScreenControl`
Interface que serve como um "filtro de visão" dos métodos do controle para a tela de configurações.

```java
public interface ISettingScreenControl
{
    public void setBotaoSelected(String idBotao, boolean selected);
    public boolean getBotaoSelected(String idBotao);
}
```

Método | Objetivo
-------| --------
`setBotaoSelected` | Define o botão definido por `idBotao` como `true` (selecionado) ou `false` (não selecionado), através do parâmetro `selected`.
`getBotaoSelected` | Retorna `true` (selecionado) ou `false` (não selecionado) para o botão definido por `idBotao`.


#### Interface `ISettingScreenCreator`
Interface que serve como um "filtro de visão" dos métodos do criador para a tela de configurações.

```java
public interface ISettingScreenCreator
{
    public Controle getControle();
    public SpriteBatch getBatch();
    public Stage getStage();
    public void setTamanhoTabuleiro(int tamanhoTabuleiro);
    public void setScreen(Screen screen);
    public Music getMusic();
}
```

Método | Objetivo
-------| --------
`getControle` | Retorna a instância do controle do jogo.
`getBatch` | Retorna o batch do jogo (relacionado à interface visual).
`getStage` | Retorna o stage do jogo (relacionado à interface visual).
`setTamanhoTabuleiro` | Define o tamanho do tabuleiro através do parâmetro `tamanhoTabuleiro`.
`setScreen` | Define a tela do jogo a ser exibida, através do parâmetro `screen`.
`getMusic` | Retorna a música do jogo.

## Plano de Exceções
Pensamos bastante sobre as exceções no Jogo 2048, mas não achamos uma sequer exceção que possa ocorrer no jogo. Inicialmente tinhamos pensado nas alternativas do tipo: e se o tabuleiro lotar, e se for clicado uma tecla errado, e se a jução de blocos não for compatível. Mas a estrutura já modelada do jogo já respondeu à todas as perguntas. (1) Se o tabuleiro lota, não a Tela de Perdeu já era chamada inicialmente; (2) se uma tecla errada for clicada, nada deve ocorrer, pois o jogo só espera as teclas que fazem parte dos movimentos; (3) se a junção de blocos não for compatível, simplesmente os blocos não se juntam e nada ocorre. Assim, não achamos que esses problemas pensados mereciam que o código os tratassem, mas sim que a estrutura do funcionamento orgânico do jogo continuasse rodando. Por isso, nos esforçamos para tentar achar outras exceções que poderiam ser tratadas com o código apropriado de exceções, mas falhamos nessa parte.
