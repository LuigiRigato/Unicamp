package pt.c40task.l05wumpus;

import java.util.Scanner;
import java.io.File;

public class AppWumpus {

   public static void main(String[] args) {
      AppWumpus.executaJogo(
            (args.length > 0) ? args[0] : null,
            (args.length > 1) ? args[1] : null,
            (args.length > 2) ? args[2] : null);
   }
   
   // imprime tabuleiro no terminal
   public static void imprimeJogo(Caverna cavernaJogo, String nome, Controle controleJogo)
   {
      char[][] board = cavernaJogo.apresentar();

      for(int i = 0; i < 4; i++)
      {
         for(int j = 0; j < 4; j++)
         {
            System.out.printf("%s", board[i][j]);
         }
         System.out.println();
      }
      System.out.printf("Player: %s \n", nome);
      System.out.println("Score: " + controleJogo.getPontuacao());
   }

   public static void executaJogo(String arquivoCaverna, String arquivoSaida,
                                  String arquivoMovimentos)
   {
      Toolkit tk = Toolkit.start(arquivoCaverna, arquivoSaida, arquivoMovimentos);

      String nome = "Alcebiades"; // nome padrão que pode ser alterado caso o usuário queira jogar manualmente
      Heroi heroiJogo = new Heroi();
      Caverna cavernaJogo = new Caverna();
      new Montador(tk, cavernaJogo, heroiJogo); // o montador é responsável pela leitura das instruções sobre o que deve ter na caverna, passando para tk
      Controle controleJogo = new Controle();
      
      heroiJogo.conectaControle(controleJogo); // o heroi pode ter acesso aos métodos do controle, pois o herói é interessado pelos métodos de movimentos
      controleJogo.conectaHeroi(heroiJogo); // o controle pode ter acesso aosmétodos do herói, pois o controle é interessado pelos métodos relativos à flecha

      String arquivoMovimentos2 = System.getProperty("user.dir")+"/src/pt/c40task/l05wumpus/"+"movements.csv";
      File file = new File(arquivoMovimentos2);

      // é verificado se não foi informado um arquivo de movimento em args e se o arquivo predominante movements.csv está vazio
      // se houver algo no arquivo movements.csv, essas informações serão consideradas no modo de jogo automático

      if(arquivoMovimentos == null && file.length() == 0L)
      // entrando no modo manual
      {
         Scanner teclado = new Scanner(System.in);
         System.out.println();
         System.out.print("Digite seu nome: ");
         nome = teclado.nextLine();
         System.out.println();
         
         imprimeJogo(cavernaJogo, nome, controleJogo);

         while (controleJogo.getStatus() == 'P' ) // enquanto o jogo estiver sendo jogado (P de playing em inglês)
         {
            System.out.print("Digite seu movimento: ");
            String movimentoAtual = teclado.nextLine();
            System.out.println();

            controleJogo.movimentosArquivo(cavernaJogo, movimentoAtual, 0); // realiza-se o movimento único (posição 0) que o usuário digitou

            System.out.println();
            tk.writeBoard(cavernaJogo.apresentar(), controleJogo.getPontuacao(), controleJogo.getStatus());
            imprimeJogo(cavernaJogo, nome, controleJogo);

            if (controleJogo.getAlerta() != null) // o alerta, quando existir, avisará a presença de brisas e fedores na sala do herói
            {
               System.out.println("Alerta: " + controleJogo.getAlerta());
            }
            System.out.println();
         }

         teclado.close();
      }
      else
      // entrando no modo automático, em que o tk sabe o arquivo relativos aos movimentos
      {         
         String movements = tk.retrieveMovements();
         System.out.println("=== Movimentos");
         System.out.println(movements);

         for(int i = 0; i < movements.length(); i++)
         {
            controleJogo.movimentosArquivo(cavernaJogo, movements, i); //// realiza-se o movimento que está sendo lido (posição i) do arquivo
            if(controleJogo.getStatus() != 'P') // se o jogo acabar
            {
               tk.writeBoard(cavernaJogo.apresentar(), controleJogo.getPontuacao(), controleJogo.getStatus());
               break;
            }
            else
            {
               tk.writeBoard(cavernaJogo.apresentar(), controleJogo.getPontuacao(), controleJogo.getStatus());
            }
         }
      }

      System.out.println("=== Última Caverna");
      imprimeJogo(cavernaJogo, nome, controleJogo);
      switch (controleJogo.getStatus()) {
         case 'W':
            System.out.println("Voce ganhou =D !!!");
            break;
         case 'L':
            System.out.println("Voce perdeu =( !!!");
            break;
         case 'Q':
            System.out.println("Volte sempre !");
            break;
      }
      tk.writeBoard(cavernaJogo.apresentar(), controleJogo.getPontuacao(), controleJogo.getStatus());
      tk.stop();
   }

}
