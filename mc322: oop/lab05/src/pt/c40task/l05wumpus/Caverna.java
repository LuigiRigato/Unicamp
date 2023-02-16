package pt.c40task.l05wumpus;

public class Caverna
{
    private Salas[][] tabuleiro = new Salas[4][4];
    private char[][] cave = new char[4][4];

    public Caverna()
    {
        // setup inicial do tabuleiro com uma sala em cada posição
        for(int i = 0; i < 4; i++)
        {
            for(int j = 0; j < 4; j++)
            {
                tabuleiro[i][j] = new Salas();
            }
        }
    }

    // recebe o componente predominante da sala posicionada na posição indicada
    public Componentes getComponente(int linha, int coluna, char info)
    {
        return tabuleiro[linha][coluna].getComponente(info);
    }

    // adiciona um componente recebido na linha e na coluna indicadas do tabuleiro
    public void addComponente(int linha, int coluna, Componentes componente)
    {
        tabuleiro[linha][coluna].addComponente(componente);
    }

    // remove um componente recebido da linha e da coluna indicadas do tabuleiro
    public void delComponente(int linha, int coluna, Componentes componente)
    {
        tabuleiro[linha][coluna].delComponente(componente);
    }

    // retorna uma matriz de char com as informações do componente predominante de cada sala
    public char[][] apresentar()
    {
        for(int i = 0; i < 4; i++)
        {
            for(int j = 0; j < 4; j++)
            {
                if(tabuleiro[i][j].getComponente('-') != null) // se a sala ainda não tiver sido descoberta
                    cave[i][j] = '-';
                else if(tabuleiro[i][j].getComponente('W') != null) // se tiver Wumpus na sala
                    cave[i][j] = 'W';
                else if(tabuleiro[i][j].getComponente('O') != null) // se tiver Ouro na sala
                    cave[i][j] = 'O';
                else if(tabuleiro[i][j].getComponente('B') != null) // se tiver Buraco na sala
                        cave[i][j] = 'B';
                else if(tabuleiro[i][j].getComponente('P') != null) // se o Herói estiver na sala
                    cave[i][j] = 'P';
                else if(tabuleiro[i][j].getComponente('f') != null) // se tiver fedor na sala
                    cave[i][j] = 'f';
                else if(tabuleiro[i][j].getComponente('b') != null) // se tiver brisa na sala
                    cave[i][j] = 'b';
                else // se a sala for vazia e já tiver sido visitada
                    cave[i][j] = '#';
            }
        }
        return cave;
    }
}
