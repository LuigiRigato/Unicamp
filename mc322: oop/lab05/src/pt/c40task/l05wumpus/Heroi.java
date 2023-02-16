package pt.c40task.l05wumpus;
import java.util.Random;

public class Heroi extends Componentes
{
    private char info = 'P';
    private boolean flechaUsada = false;
    private boolean flechaEquipada = false;
    private Controle controle;

    public boolean getFlechaUsada()
    {
        return flechaUsada;
    }

    public void setFlechaUsada(boolean flechaUsada)
    {
        this.flechaUsada = flechaUsada;
    }

    public boolean getFlechaEquipada()
    {
        return flechaEquipada;
    }

    public void setFlechaEquipada(boolean flechaEquipada)
    {
        this.flechaEquipada = flechaEquipada;
    }

    public char getInfo()
    {
        return info;
    }

    // o herói fica responsável pelos movimentos, tendo referência para a caverna, e para o controle
    public void movimentar(int linhaInicio, int colunaInicio, int linhaFim, int colunaFim, Caverna caverna)
    {
        if(caverna.getComponente(linhaFim, colunaFim, 'W') != null) // se for wumpus
        {
            if(flechaEquipada && ganharBatalha())
            {
                controle.atualizaPontuacao(500);
                caverna.delComponente(linhaFim, colunaFim, caverna.getComponente(linhaFim, colunaFim, 'W')); // deleta o wumpus

                // deletando os fedores
                if(linhaFim-1 >= 0)
                    caverna.delComponente(linhaFim-1, colunaFim, caverna.getComponente(linhaFim-1, colunaFim, 'f'));
                if(linhaFim+1 < 4)
                    caverna.delComponente(linhaFim+1, colunaFim, caverna.getComponente(linhaFim+1, colunaFim, 'f'));
                if(colunaFim-1 >= 0)
                    caverna.delComponente(linhaFim, colunaFim-1, caverna.getComponente(linhaFim, colunaFim-1, 'f'));
                if(colunaFim-1 < 4)
                    caverna.delComponente(linhaFim, colunaFim+1, caverna.getComponente(linhaFim, colunaFim+1, 'f'));

                flechaEquipada = false;
                System.out.println("Você matou o Wumpus :)");
            } 
            else 
            {
                controle.atualizaPontuacao(-1000);
                controle.perdeu();
            }
        } 
        else if(caverna.getComponente(linhaFim, colunaFim, 'B') != null) // s o herói está em uma posição do tabuleiro em que há buraco, ele perde
        {
            controle.atualizaPontuacao(-1000);
            controle.perdeu();
        }
    
        if (caverna.getComponente(linhaFim, colunaFim, 'f') != null)
        {
            controle.setAlerta("Estou sentindo um fedor :0");
        }
        else if(caverna.getComponente(linhaFim, colunaFim, 'b') != null)
        {
            controle.setAlerta("Estou sentindo uma brisa ~~~");
        }
        else
        {
            controle.setAlerta(null);
        }    

        if(caverna.getComponente(linhaFim, colunaFim, '-') != null) // se o espaço não tinha sido vistado anteriormente, removemos o -, restando o #
            caverna.delComponente(linhaFim, colunaFim, caverna.getComponente(linhaFim, colunaFim, '-'));

        caverna.addComponente(linhaFim, colunaFim, caverna.getComponente(linhaInicio, colunaInicio, 'P')); // tiramos o herói da sala anterior
        caverna.delComponente(linhaInicio, colunaInicio, caverna.getComponente(linhaInicio, colunaInicio, 'P')); // colocando o herói na nova sala

        controle.atualizaPontuacao(-15);
    }

    // o herói tem uma chance de 50% de ganhar esta batalha
    public boolean ganharBatalha()
    {
        Random random = new Random();
        boolean resultado = random.nextBoolean();
        return resultado;
    }

    // o herói pode utilizar os métodos do controle
    public void conectaControle(Controle controle)
    {
        this.controle = controle;
    }
}