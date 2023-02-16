package pt.c40task.l05wumpus;

public class Wumpus extends Componentes
{
    private char info = 'W';

    public Wumpus(int linha, int coluna, Caverna caverna)
    {
        // posicionamento dos fedores em volta do wumpus
        if(linha-1 >= 0)
            caverna.addComponente(linha-1, coluna, new Fedor());
        if(coluna-1 >= 0)
            caverna.addComponente(linha, coluna-1, new Fedor());
        if(linha+1 < 4)
            caverna.addComponente(linha+1, coluna, new Fedor());
        if(coluna+1 < 4)
            caverna.addComponente(linha, coluna+1, new Fedor());

    }

    public char getInfo()
    {
        return info;
    }
}
