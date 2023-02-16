package pt.c02oo.s02classe.s03lombriga;

public class AppLombriga {

   public static void main(String[] args) {
      Toolkit tk = Toolkit.start();
      
      String lombrigas[] = tk.recuperaLombrigas();
      for (int l = 0; l < lombrigas.length; l++)
      {
         Animacao lombriga_animada = new Animacao(lombrigas[l]);
         AquarioLombriga lombriga = new AquarioLombriga(lombriga_animada.tamanho_aquario, lombriga_animada.tamanho_lombriga, lombriga_animada.posicao_cabeca);
         lombriga_animada.conecta(lombriga);
         tk.gravaPasso("=====");
         tk.gravaPasso(lombriga_animada.apresenta());
         for (int index = 6; index < lombrigas[l].length(); index++)
         {
            lombriga_animada.passo();
            tk.gravaPasso(lombriga_animada.apresenta());
         }
      }
      
      tk.stop();
   }

}