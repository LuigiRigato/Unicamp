package pt.c40task.l05wumpus;

public class Controle 
{
    private static int pontuacao = 0;
    private int linhaH, colunaH; // posição do herói
    private boolean achouOuro = false;
    private String alerta = null; // alerta que será mostrado em casos especiais (brisa, fedor)
    private char status = 'P'; // status do jogo (P - playing / L - lose / W - win)
    private Heroi heroi;

    // função responsável por realizar a movimentação do herói e suas ações com base no movimento indicado
    public void movimentosArquivo(Caverna caverna, String movimentos, int contaMovimento)
    {
        char movimentoAtual = movimentos.charAt(contaMovimento); // determinar o char do movimento com base na string fornecida

        if(movimentoAtual == 'w' && linhaH-1 >= 0) // se o movimento for 'w'
        {
            heroi.movimentar(linhaH, colunaH, linhaH-1, colunaH, caverna);
            linhaH--;
        } 
        else if(movimentoAtual == 's' && linhaH+1 < 4) // se o movimento for 's'
        {
            heroi.movimentar(linhaH, colunaH, linhaH+1, colunaH, caverna);
            linhaH++;
        }
        else if(movimentoAtual == 'a' && colunaH-1 >= 0) // se o movimento for 'a'
        {
            heroi.movimentar(linhaH, colunaH, linhaH, colunaH-1, caverna);
            colunaH--;
        }
        else if(movimentoAtual == 'd' && colunaH+1 < 4) // se o movimento for 'd'
        {
            heroi.movimentar(linhaH, colunaH, linhaH, colunaH+1, caverna);
            colunaH++;
        }
        else if (movimentoAtual == 'c' && caverna.getComponente(linhaH, colunaH, 'O') != null) // se o mov. for 'c'
        {
            achouOuro = true;
            caverna.delComponente(linhaH, colunaH, caverna.getComponente(linhaH, colunaH, 'O'));
            System.out.println("Você coletou o ouro :)");
        }
        else if (movimentoAtual == 'q') // se o jogador quiser sair do jogo
        {
            sair();
            return;
        }
        else if(movimentoAtual == 'k') // se o jogador armar a flecha
        {
            if(heroi.getFlechaUsada()) // se a flecha já tiver sido utilizada
            {
                System.out.println("A flecha já foi utilizada.");
            }
            else // se a flecha ainda não tiver sido utilizada
            {
                heroi.setFlechaUsada(true);
                heroi.setFlechaEquipada(true);
                pontuacao -= 100;
                System.out.println("Flecha equipada :)");
            }
        }
        else // se o caractere for inválido ou se sair do tabuleiro
        {
            System.out.println("Caractere de entrada inválido.");
            return;
        }

        if(linhaH == 0 && colunaH == 0 && achouOuro) // se o jogador voltar para a entrada da caverna com o ouro
        {
            pontuacao += 1000;
            ganhou();
            return;
        }
    }

    public void conectaHeroi(Heroi heroi)
    {
        this.heroi = heroi;
    }

    public char getStatus() {
        return status;
    }

    public int getPontuacao()
    {
        return pontuacao;
    }

    public void atualizaPontuacao(int difPontuacao)
    {
        pontuacao += difPontuacao;
    }

    public String getAlerta()
    {
        return alerta;
    }

    public void setAlerta(String alerta) {
        this.alerta = alerta;
    }

    public void perdeu()
    {
        status = 'L';
    }
    
    public void ganhou()
    {
        status = 'W';
    }

    public void sair()
    {
        status = 'Q';
    }
}