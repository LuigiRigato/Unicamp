int read(int __fd, const void *__buf, int __n)
{
  int bytes;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall read (63) \n"
    "ecall \n"
    "mv %0, a0"
    : "=r"(bytes)  // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return bytes;
}
 
void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

int power(int base, int potencia)
{
  if (potencia == 0)
  {
    return 1;
  }

  int resultado = base;
  for (int index = 1; index < potencia; index++)
  {
    resultado *= base;
  }
  return resultado;
}

int charToDec(char caracter)
{
    int dec;

    if (caracter >= 48 && caracter <= 57) // intervalo dos char de 0 a 9 para o intervalo dos int de 0 a 9
    {
        dec = caracter - 48;
    }
    else if(caracter >= 97 && caracter <= 102) // intervalo dos char de "a" a "f" para o intervalo dos inteiros de 10 a 15, em hexadecimal
    {
        dec = caracter - 87;
    }
    else if(caracter >= 65 && caracter <= 70) // intervalo dos char de "A" a "F" para o intervalo dos inteiros de 10 a 15, em hexadecimal
    {
        dec = caracter - 55;
    }

    return dec;
}

char decToChar(int dec)
{
    char caracter;

    if (dec >= 0 && dec <= 9) // intervalo dos int de 0 a 9 para o intervalo dos char de 0 a 9
    {
        caracter = dec + 48;
    }
    else if(dec >= 10 && dec <= 15) // intervalo dos inteiros de 10 a 15 para o intervalo dos char de "a" a "f", em hexadecimal
    {
        caracter = dec + 87;
    }

    return caracter;
}

int hexToBin(char hex[], char bin[], int n)
// cada dígito em hexadecimal será traduzido para quatro em binário, através do resto da divisão sucessiva do número por 2
// o resto é guardado e, depois invertido para formar o número em binário (o resto da primeira divisão é o dígito menos significativo)
{
    int numerador;
    int tamanho = 0;
    int restos[4];

    bin[0] = '0';
    bin[1] = 'b';

    for(int indexHex = 2; indexHex < n; indexHex++)
    {
        numerador = charToDec(hex[indexHex]);
        for(int index = 0; index < 4; index++)
        {
            restos[index] = numerador % 2;
            numerador /= 2;
        }

        for(int index = 0; index < 4; index++)
        {
            bin[index + tamanho + 2] = decToChar(restos[3 - index]);
        }
        tamanho += 4;
    }

    return tamanho + 2;
}

void desinverteVetor(char vetor[], char antiVetor[], int tamanho, int inicio)
{
  for(int index = 0; index < tamanho; index++)
  {
      vetor[index + inicio] = antiVetor[tamanho - index - 1];
  }
}

int divisoesSucessivas(int numero, char antiRestos[], int divisor, int inicio)
{
  char restos[35];
  int tamanho = 0;
  
  for(int index = 0; numero != 0 && tamanho < 32; index++)
  {
    restos[index] = decToChar(numero % divisor);
    numero /= divisor;
    tamanho++;
  }

  desinverteVetor(antiRestos, restos, tamanho, inicio);

  return tamanho;
}

int strToInt(int n, char number[], int base, int inicio)
{
  int total = 0;

  for (int index = inicio; index < n; index++)
  {
    total += charToDec(number[index]) * power(base, n - index - 1);
  }

  return total;
}

int binToHex(char bin[], char hex[])
{
    int total = 0;
    int posicao = 0;
    int tamanho = 0;

    hex[0] = '0';
    hex[1] = 'x';

    for(int grupo = 0; grupo < 8; grupo++)
    {
        for(int index = 3; index >= 0; index++)
        {
            total += bin[posicao++] * power(2, index);
            tamanho++;
        }
        divisoesSucessivas(total, hex, 16, 2);
        total = 0;
    }

    return tamanho + 2;
}

int positiveBinToDec(char bin[], char dec[], int tamanhoBin)
{
  int numeroBin = strToInt(tamanhoBin, bin, 2, 2);
  int tamanho = divisoesSucessivas(numeroBin, dec, 10, 0);

  return tamanho;
}

int negativeBinToDec(char bin[], char dec[], int tamanhoBin)
{
  char antiBin[35];
  char antiRestos[35]; // inverso do resto, ou seja, se o resto for 1, é armazenado 0 e vice-versa

  antiBin[0] = '0';
  antiBin[1] = 'b';

  for(int index = 2; index < tamanhoBin; index++)
  {
    antiBin[index] = decToChar(1 - charToDec(bin[index]));
  }

  int numeroBin = strToInt(tamanhoBin, antiBin, 2, 2);
  numeroBin++;
  int tamanho = divisoesSucessivas(numeroBin, dec, 10, 0);

  return tamanho;
}


int decPositiveToBin(char dec[], char bin[], int n)
// os restos das divisões sucessivas do decimal por 2 forma o número binário invertido
{
  bin[0] = '0';
  bin[1] = 'b';

  int numeroDec = strToInt(n, dec, 10, 0);
  int tamanho = divisoesSucessivas(numeroDec, bin, 2, 2);

  return tamanho + 2;
}

int decNegativeToBin(char dec[], char bin[], int n)
// o inverso dos restos das divisões sucessivas do decimal por 2 forma o número binário invertido
// deve-se subtrair 1 antes de passsar para binário
{
  int tamanho = 0;
  char antiRestos[35]; // inverso do resto, ou seja, se o resto for 1, é armazenado 0 e vice-versa
  char binIncompleto[35];

  bin[0] = '0';
  bin[1] = 'b';

  int numeroDec = strToInt(n, dec, 10, 1);
  numeroDec--;

  for(int index = 0; numeroDec != 0 && tamanho < 32; index++) // restos das divisões sucessivas por dois
  {
      antiRestos[index] = decToChar(1 - (numeroDec % 2));
      numeroDec /= 2;
      tamanho++;
  }

  desinverteVetor(binIncompleto, antiRestos, tamanho, 2);

  int uns = 32 - tamanho;

  for(int index = 0; index < uns; index++)
  {
    bin[index + 2] = '1';
  }
  for(int index = 0; index < tamanho; index++)
  {
    bin[uns + index + 2] = binIncompleto[index]; // soma dois para não pegar o "0b" do começo do bin
  }

  return tamanho + 2 + uns;
}

int decPositiveToHex(char dec[], char hex[], int n)
{
  hex[0] = '0';
  hex[1] = 'x';

  int numeroDec;
  numeroDec = strToInt(n, dec, 10, 0);

  int tamanho = divisoesSucessivas(numeroDec, hex, 16, 2);

  return tamanho + 2;
}

int changeEnd(char bin[], char antiDec[], int tamanhoBin)
// criamos um vetor de char bin, mas com zeros à esquerda para completar 32 bits
// binCompleto não começa com "0b" só para simplificar
// antiBin é o bin com o endianess invertido
{
  char binCompleto[35];
  char antiBin[35];
  char restos[35];

  int zeros = 32 + 2 - tamanhoBin;

  for(int index = 0; index < zeros; index++)
  {
    binCompleto[index] = '0';
  }
  for(int index = 0; index < tamanhoBin; index++)
  {
    binCompleto[zeros + index] = bin[index + 2]; // soma dois para não pegar o "0b" do começo do bin
  }

  int posicao = 0;
  for(int indexBytes = 3; indexBytes >= 0; indexBytes--)
  {
    for(int indexBits = 0; indexBits < 8; indexBits++)
    {
      antiBin[posicao++] = binCompleto[indexBytes * 8 + indexBits];
    }
  }

  int numero = strToInt(32, antiBin, 2, 0);
  int tamanho = divisoesSucessivas(numero, antiDec, 10, 0); // transforma de int em vetor de char

  return tamanho;
}

int main()
{
  char str[20];
  char dec[35];
  char bin[35];
  char hex[35];
  char decEnd[35];
  int tamanhoBin;
  int tamanhoDec;
  int tamanhoHex;
  int tamanhoEnd;
  int n = read(0, str, 20);
  n--; // retirando o \0 da contagem

  if(str[1] == 'x')
  {
    tamanhoBin = hexToBin(str, bin, n);
    if(tamanhoBin == 34 && bin[2] == '1') // decimal vai ser negativo
    {
      tamanhoDec = negativeBinToDec(bin, dec, tamanhoBin);
    }
    else
    {
      tamanhoDec = positiveBinToDec(bin, dec, tamanhoBin);
    }
    tamanhoEnd = changeEnd(bin, decEnd, tamanhoBin);    

    write(1, bin, tamanhoBin);
    write(1, "\n", 1);
    write(1, dec, tamanhoDec);
    write(1, "\n", 1);
    write(1, str, n);
    write(1, "\n", 1);
    write(1, decEnd, tamanhoEnd);
    write(1, "\n", 1);
  }
  else if (str[0] == '-')
  {
    tamanhoBin = decNegativeToBin(str, bin, n);
    tamanhoHex = binToHex(bin, hex);
    tamanhoEnd = changeEnd(bin, decEnd, tamanhoBin);

    write(1, bin, tamanhoBin);
    write(1, "\n", 1);
    write(1, str, n);
    write(1, "\n", 1);
    write(1, hex, tamanhoHex);
    write(1, "\n", 1);
    write(1, decEnd, tamanhoEnd);
    write(1, "\n", 1);
  }
  else
  {
    tamanhoBin = decPositiveToBin(str, bin, n);
    tamanhoHex = decPositiveToHex(str, hex, n);
    tamanhoEnd = changeEnd(bin, decEnd, tamanhoBin);

    write(1, bin, tamanhoBin);
    write(1, "\n", 1);
    write(1, str, n);
    write(1, "\n", 1);
    write(1, hex, tamanhoHex);
    write(1, "\n", 1);
    write(1, decEnd, tamanhoEnd);
    write(1, "\n", 1);
  }

  return 0;
}
 
void _start()
{
  main();
}
