package pt.c40task.l05wumpus;

public class Vazio extends Componentes
// componente vazio se faz presente na sala se a sala não tiver outros componentes (com exceção do vazio visitado) e a sala ainda não foi visitada
{
    private char info = '-';

    public char getInfo()
    {
        return info;
    }
}
