import java.util.Random;

class Main {

  /*
   * Treinar os pesos
   */
  public static void percepton(int entrada[][], int saida[], Pesos pesos, double taxaAprendizado, int round) {
    boolean correto = false;
    int k = 0;
    double erro,
           somatorio;
    Random r = new Random();   // Geração de valores aleatórios
    
    pesos.peso[0] = r.nextInt(100) / 100.0;
    pesos.peso[1] = r.nextInt(100) / 100.0;

    while (correto != true && k < round) {
      for (int i = 0; i < entrada.length; i++) {
        somatorio = entrada[i][0] * pesos.peso[0] + entrada[i][1] * pesos.peso[1];

        if (saida[i] == somatorio) {
          correto = true;
          break;
        }

        erro = saida[i] - somatorio;
        pesos.peso[0] += erro * taxaAprendizado * entrada[i][0];
        pesos.peso[1] += erro * taxaAprendizado * entrada[i][1];
      }
      k++;
    }
  }

  /*
   * Imprimir pesos
   */
  public static void imprimirPesos(Pesos pesos) {
    for (int j = 0; j < pesos.peso.length; j++) {
      System.out.printf("p[%d] = %.2f\n",j ,pesos.peso[j]);
    }
  }

  /*
   * Soma de números iguais com treinamento
   */
  public static void somatorio(Pesos p, int qtdNumeros) {
    int num1, num2;
    double somatorio;

    for (int i = 0; i < qtdNumeros; i++) {
      num1 = (i+1);
      num2 = (i+1);
      somatorio = num1 * p.peso[0] + num2 * p.peso[1];
      System.out.printf("%d + %d = %.1f\n", num1, num2, somatorio); 
    }
  }

  /*
   * Programa principal que usa a rede neural Perceptron
   */
  public static void main(String[] args) {
    int numRodada = 30;              // Número de rodadas
    double taxaAprendizado = 0.05;   // Taxa de aprendizado (entre 0 e 1)
    int[][] entrada = new int[5][2]; // Matriz com conjunto de cinco amostras
    int[] saida = new int[5];        // Saída de cada amostra
    Pesos pesos = new Pesos();       // Peso dos elementos por amostra
    
    // Preencher matriz com dois números iguais por amostra
    for (int i = 0; i < entrada.length; i++) {
      entrada[i][0] = i+2;
      entrada[i][1] = i+2;
      saida[i] = entrada[i][0] + entrada[i][1];
    }

    percepton(entrada, saida, pesos, taxaAprendizado, numRodada);
    imprimirPesos(pesos);
    somatorio(pesos, 160);
  }
}

/*
 * Classe responsável pelos pesos dos elementos
 */
class Pesos { 
  double[] peso = new double[2]; // Valores do peso 
}