package pt.c02oo.s02classe.s03lombriga;

public class AquarioLombriga
{
   int tamanho_aquario, tamanho_lombriga, posicao_cabeca, posicao_cauda;
   boolean cabeca_esquerda = true;
   char desenho[];
    
    AquarioLombriga(int tamanho_aquario, int tamanho_lombriga, int posicao_cabeca)
    {   
        if (posicao_cabeca < 1 || posicao_cabeca > tamanho_aquario)
        // se a posição for inválida
        {
            posicao_cabeca = 1;
        }

        posicao_cauda = posicao_cabeca + tamanho_lombriga - 1;
        if (posicao_cauda > tamanho_aquario)
        {
            tamanho_lombriga = tamanho_aquario;
            posicao_cabeca = 1;
            posicao_cauda = tamanho_aquario;
        }
        
        desenho = new char[tamanho_aquario];

        for (int index = 0; index < tamanho_aquario; index++)
        {
            if (index == posicao_cabeca - 1)
            {
                desenho[index] = 'O';
            }
            else if (index >= posicao_cabeca && index < posicao_cauda)
            {
                desenho[index] = '@';
            }
            else
            {
                desenho[index] = '#';
            }
        }

        this.tamanho_aquario = tamanho_aquario;
        this.tamanho_lombriga = tamanho_lombriga;
        this.posicao_cabeca = posicao_cabeca;
    }
    
    void crescer()
    /* A lombriga deve crescer se haver espaço para isso, ou seja, caso ela esteja virada para a esquerda, deve haver pelo menos um # na 
    última posição do aquário; caso ela não esteja virada para a esquerda, deve haver pelo menos um # na primeira posição do aquário. */
    {
        if ((cabeca_esquerda && desenho[tamanho_aquario - 1] == '#'))
        {
            tamanho_lombriga++;
            desenho[posicao_cauda] = '@';
            posicao_cauda++;
        }
        else if (!cabeca_esquerda && desenho[0] == '#')
        {
            tamanho_lombriga++;
            desenho[posicao_cauda - 2] = '@';
            posicao_cauda--;
        }
    }

    void virar()
    /* A lombriga inverte o símbolo da cabeça com a cauda para virar. */
    {
        desenho[posicao_cabeca - 1] = '@';
        desenho[posicao_cauda - 1] = 'O';
        cabeca_esquerda = !cabeca_esquerda;
        int posicao_auxiliar = posicao_cabeca;
        posicao_cabeca = posicao_cauda;
        posicao_cauda = posicao_auxiliar;
    }

    void mover()
    /* A lombriga se move para a direação da sua cabeça. Caso não haja espaço para tal, ela vira. */
    {
        if (cabeca_esquerda)
        {
            if (desenho[0] == '#')
            // tem espaço para ela se mover
            {
                tamanho_lombriga++;
                desenho[posicao_cabeca - 2] = 'O';
                desenho[posicao_cabeca - 1] = '@';
                desenho[posicao_cauda - 1] = '#';
                posicao_cabeca--;
                posicao_cauda--;
            }
            else
            {
                this.virar();
            }
        }
        else
        {
            if (desenho[tamanho_aquario - 1] == '#')
            // tem espaço para ela se mover
            {
                tamanho_lombriga++;
                desenho[posicao_cabeca] = 'O';
                desenho[posicao_cabeca - 1] = '@';
                desenho[posicao_cauda - 1] = '#';
                posicao_cabeca++;
                posicao_cauda++;                
            }
            else
            {
                this.virar();
            }
        }
    }

    String apresenta()
    {
    	return String.valueOf(desenho);
    }
}
