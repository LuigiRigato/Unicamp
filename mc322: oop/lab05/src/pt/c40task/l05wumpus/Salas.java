package pt.c40task.l05wumpus;

public class Salas
{
    private Componentes[] componentes = new Componentes[8];
    // vetor dos 8 componentes possíveis: herói, brisa, fedor, wumpus, buraco, ouro, espaço vazio e o espaço vazio que já foi vistado
    // o vetor contém o componente quando este se faz presente na sala

    public Componentes getComponente(char info)
    {
        switch (info)
        {
            case '-':
                return componentes[0];
            case 'O':
                return componentes[1];
            case 'W':
                return componentes[2];
            case 'B':
                return componentes[3];
            case 'P':
                return componentes[4];
            case 'f':
                return componentes[5];
            case 'b':
                return componentes[6];
            case '#':
                return componentes[7];
        }
        return null;
    }

    // adiciona a presença de certo componente no vetor da sala
    public void addComponente(Componentes componente)
    {   
        switch (componente.getInfo())
        {
            case '-':
                componentes[0] = componente;
                break;
            case 'O':
                if(componentes[2] == null && componentes[3] == null) // não pode haver ouro, wumpus ou buraco em uma mesma sala
                    componentes[1] = componente;
                else
                {
                    System.out.println("Esse componente não pode ser inserido aqui.");
                    System.exit(0);
                }
                break;
            case 'W':
                if(componentes[1] == null && componentes[3] == null)
                    componentes[2] = componente;
                else
                {
                    System.out.println("Esse componente não pode ser inserido aqui.");
                    System.exit(0);
                }
                break;
            case 'B':
                if(componentes[1] == null && componentes[2] == null)
                    componentes[3] = componente;
                else
                {
                    System.out.println("Esse componente não pode ser inserido aqui.");
                    System.exit(0);
                }
                break;
            case 'P':
                componentes[4] = componente;
                break;
            case 'f':
                componentes[5] = componente;
                break;
            case 'b':
                componentes[6] = componente;
                break;
            case '#':
                componentes[7] = componente;
                break;
        }
    }

    // retira a presença do componente no vetor da sala
    public void delComponente(Componentes componente)
    {
        switch (componente.getInfo())
        {
            case '-':
                componentes[0] = null;
                break;
            case 'O':
                componentes[1] = null;
                break;
            case 'W':
                componentes[2] = null;
                break;
            case 'P':
                componentes[4] = null;
                break;
            case 'f':
                componentes[5] = null;
                break;
        }
    }
}