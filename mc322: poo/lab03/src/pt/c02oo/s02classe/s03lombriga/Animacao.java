package pt.c02oo.s02classe.s03lombriga;

public class Animacao
{
    int tamanho_aquario, tamanho_lombriga, posicao_cabeca, index_comando = 6;
    AquarioLombriga lombriga;
    char instrucoes[];

    Animacao(String instrucoes)
    {
        this.instrucoes = instrucoes.toCharArray();
        tamanho_aquario = Integer.parseInt(String.valueOf(this.instrucoes[0]) + String.valueOf(this.instrucoes[1]));
        tamanho_lombriga = Integer.parseInt(String.valueOf(this.instrucoes[2]) + String.valueOf(this.instrucoes[3]));
        posicao_cabeca = Integer.parseInt(String.valueOf(this.instrucoes[4]) + String.valueOf(this.instrucoes[5]));
    }

    void conecta(AquarioLombriga lombriga)
    {
        this.lombriga = lombriga;
    }

    String apresenta()
    {
        return lombriga.apresenta();
    }

    void passo()
    {
        if (instrucoes[index_comando] == 'C')
        {
        	lombriga.crescer();
        }
        else if (instrucoes[index_comando] == 'M')
        {
            lombriga.mover();
        }
        else
        {
            lombriga.virar();
        }

        index_comando++;
    }
}