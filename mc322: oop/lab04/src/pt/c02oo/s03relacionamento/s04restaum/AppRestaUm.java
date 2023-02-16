package pt.c02oo.s03relacionamento.s04restaum;

public class AppRestaUm {

   public static void main(String[] args) {
      AppRestaUm.executaJogo(null, null);
   }
   
   public static void executaJogo(String arquivoEntrada, String arquivoSaida) {
      Toolkit tk = Toolkit.start(arquivoEntrada, arquivoSaida);
      
      String commands[] = tk.retrieveCommands();
      
      Tabuleiros tabuleiro = new Tabuleiros();

      tk.writeBoard("Tabuleiro inicial", tabuleiro.apresentar());

      
      for (int index = 0; index < commands.length; index++)
      // para cada comando, o tabuleiro interpreta os comandos, movimenta as peças e depois apresenta o resultado
      {
         tabuleiro.ler_comandos(commands[index]);
         tabuleiro.movimentar();
         tk.writeBoard("source: " + tabuleiro.comandos[0] + tabuleiro.comandos[1] + 
                       "; target: " + tabuleiro.comandos[3] + tabuleiro.comandos[4], tabuleiro.apresentar());
      }

      tk.stop();
   }

}