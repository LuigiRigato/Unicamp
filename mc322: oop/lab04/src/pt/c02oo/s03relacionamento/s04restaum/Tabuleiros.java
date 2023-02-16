package pt.c02oo.s03relacionamento.s04restaum;

public class Tabuleiros
{
    public char[] comandos = new char[5];
    public char[][] desenho = new char[7][7];
    public int origem_linha, origem_coluna, destino_linha, destino_coluna, diferenca_linhas, diferenca_colunas, comido_linha, comido_coluna;
    public Pecas[][] board = new Pecas[7][7];

    public Tabuleiros()
    // a classe Tabuleiros tem uma matriz de objetos de Peças, chamada board, e uma matriz de char, chamada desenho.
    // ambas são inicialmente montadas aqui no construtor e são posteriormente alteradas nos outros métodos.
    {
        for (int linha = 0; linha < 7; linha++)
        {
            for (int coluna = 0; coluna < 7; coluna++)
            {
                Pecas peca = new Pecas();
                if ((linha > 1 && linha < 5) || (coluna > 1 && coluna < 5))
                {
                peca.setInfo('P');
                }
                else
                {
                peca.setInfo(' ');
                }
                if (linha == 3 && coluna == 3)
                {
                peca.setInfo('-');
                }

                board[linha][coluna] = peca;
            }
        }
    }
    public void ler_comandos(String comandos)
    // o tabuleiro interpreta os comandos dados do tipo "a1:c1" e armazena em um vetor de caracteres e, posteriormente, em variáveis int separadas
    {
        this.comandos = comandos.toCharArray();
        origem_linha = this.comandos[0] - 'a';
        origem_coluna = this.comandos[1] - '1';
        destino_linha = this.comandos[3] - 'a';
        destino_coluna = this.comandos[4] - '1';
        comido_linha = (origem_linha + destino_linha) / 2;
        comido_coluna = (origem_coluna + destino_coluna) / 2;
        // as posições comidas ficam entre a origem e o destino
    }
    
    public boolean movimento_valido()
    /*
    o tabuleiro procura por movimentos inválidos:
    caso 1: deve sempre haver uma peça na origem e na posição comida e não deve haver uma peça no destino
    caso 2: o espaçamento entre o destino e a origem deve ser de: (2 linhas e estar na mesma coluna) ou (2 colunas e estar na mesma linha)
    caso 3: as peças indicadas devem estar dentro do tabuleiro, isto é, com linhas e colunas entre 0 e 7
    */

    {        
        if (board[origem_linha][origem_coluna].getInfo() == 'P' && board[destino_linha][destino_coluna].getInfo() == '-' && board[comido_linha][comido_coluna].getInfo() == 'P')
        {
            diferenca_linhas = (origem_linha > destino_linha) ? origem_linha - destino_linha : destino_linha - origem_linha;
            diferenca_colunas = (origem_coluna > destino_coluna) ? origem_coluna - destino_coluna : destino_coluna - origem_coluna;

            if ((diferenca_linhas == 2 && diferenca_colunas == 0) || (diferenca_colunas == 2 && diferenca_linhas == 0))
            {
                if (origem_linha < 7 && origem_coluna < 7 && destino_linha < 7 && destino_coluna < 7 && origem_linha >= 0 && origem_coluna >= 0 && destino_linha >= 0 && destino_coluna >= 0)
                {
                    return true;
                }    
            }
        }
        return false;
    }

    public void movimentar()
    // realiza o movimenta por alterar a informação na peça de origem, na peça comida e na peça de destino; de "P" para "-" e vice-versa
    {
        if (movimento_valido())
        {
            board[origem_linha][origem_coluna].setInfo('-');
            board[destino_linha][destino_coluna].setInfo('P');
            board[comido_linha][comido_coluna].setInfo('-');
        }
    }

    public char[][] apresentar()
    // transfere todas as informações de caracteres da matriz de Peças para a matriz de char, apresentando-a
    {
        for (int linha = 0; linha < 7; linha++)
        {
            for (int coluna = 0; coluna < 7; coluna++)
            {
                desenho[linha][coluna] = board[linha][coluna].getInfo();
            }
        }

        return desenho;
    }
}