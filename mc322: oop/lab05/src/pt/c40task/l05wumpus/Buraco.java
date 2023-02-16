package pt.c40task.l05wumpus;

public class Buraco extends Componentes 
{
    private char info = 'B';

    public char getInfo()
    {
        return info;
    }

    // posiciona as brisas em volta da posição de um buraco que é fornecida
    public Buraco(int linha, int coluna, Caverna caverna)
    {
        if(linha-1 >= 0)
            caverna.addComponente(linha-1, coluna, new Brisa());
        if(coluna-1 >= 0)
            caverna.addComponente(linha, coluna-1, new Brisa());
        if(linha+1 < 4)
            caverna.addComponente(linha+1, coluna, new Brisa());
        if(coluna+1 < 4)
            caverna.addComponente(linha, coluna+1, new Brisa());

    }
}