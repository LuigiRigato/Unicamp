package pt.c02oo.s03relacionamento.s04restaum;

public class Pecas
// as peças são objetos que compõem da matriz do tabuleiro, mas apenas podem ser alteradas pelos métodos abaixo já que são privadas
{
    private char info;

    public char getInfo()
    {
        return info;
    }

    public void setInfo(char info)
    {
        this.info = info;
    }
}
