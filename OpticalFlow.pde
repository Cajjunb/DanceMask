class OpticalFlow{
    //ITERADOR NUMERO e numero maximo de iteracoes
    private int k = 0;
    private int kMax ;
    
    //CONSTANTES DE LIMITE DE FLUXO
    private final float LIMITE_MIN_X = 1.5;
    private final float LIMITE_MIN_Y = 1.5;
    
    //FRAMES E DERIVADAS
    private int frameX[][];
    private int frameY[][];
    private int frame1T[][];
    private int frameX2[][];
    private int frameY2[][];

    //FRAMES E DERIVADAS
    private float frameXFloat[][];
    private float frameYFloat[][];
    private float frame1TFloat[][];
    private float frameX2Float[][];
    private float frameY2Float[][];

    //FLUXO
    private int flowU;
    private int flowV;
    //CONSTANTE DE SMOOTH
    private int lambda;
    //operador de convolucao de matrizes
    private convolucaoOperador operador;
    
    OpticalFlow(int lambda,int kMax){
        //Inicializacao
        this.operador = new convolucaoOperador();
        this.lambda = lambda;
        this.kMax = kMax;
    }

    int [][] elevarMatrizAoQuadrado(int input[][]){
        int rows = input.length;
        int cols = input[0].length;
        int sum  = 0;
        int out[][] = new int[rows][cols];
        for(int i = 0; i < rows; ++i){
            for(int j = 0; j < cols; ++j){
                for(int n = 0 ; n < rows; ++n){
                    sum = sum + input[i][n] * input[n][j];   
                }
                out[i][j] = sum;
            }
        }
        return out;
    }

    
    float [][] elevarMatrizAoQuadrado(float input[][]){
        int rows = input.length;
        int cols = input[0].length;
        float sum  = 0;
        float out[][] = new float[rows][cols];
        for(int i = 0; i < rows; ++i){
            for(int j = 0; j < cols; ++j){
                for(int n = 0 ; n < rows; ++n){
                    sum = sum + input[i][n] * input[n][j];   
                }
                out[i][j] = sum;
            }
        }
        return out;
    }
    
    
     //<>//
    float[][][] estimarFluxo(int frame1[][],int frame2 [][]){
         //Instanciando Matrix de duplas do fluxo, cada ponto do fluxo tera um valor de u e v
         float fluxo[][][] = new float[frame1.length][frame1[0].length][2];
         //Calculando todas as derivadas dos frames necessarias para o calculo
         this.frameX = this.operador.derivarX(frame1,frame2);
         this.frameY = this.operador.derivarY(frame1,frame2);
         this.frame1T = this.operador.derivarT1T2(frame1,frame2);

         int linhas   =  frame1.length;
         int colunas  = frame1[0].length;
         float soma;
         int numeroPixels = frame1.length * frame1[0].length;
         
         // INICIALIZANDO
         for(int i = 0; i < linhas; ++i)
             for(int j = 0; j < colunas; ++j){
                 fluxo[i][j][0] = 0;
                 fluxo[i][j][1] = 0;
             }    
         do{
             //Reinicia a condicao de parada
             soma = 0;
             float fluxoMedio[][][] = this.operador.calcularMediaVetor(fluxo);
             for(int i = 0; i < linhas; ++i){
                 for(int j = 0; j < colunas; ++j){
                     /*int numeroMedia = 0;
                     int valorU      = 0;
                     int valorV      = 0;
                     //Calculando a media em geral perto
                     if(i - 1 > 0){
                         ++numeroMedia;
                         valorU += fluxo[i-1][j][0];
                         valorV += fluxo[i-1][j][1];
                     }
                     if(i + 1 < linhas){
                         ++numeroMedia;
                         valorU += fluxo[i+1][j][0];
                         valorV += fluxo[i+1][j][1];
                     }
                     if(j - 1 > 0){
                         ++numeroMedia;
                         valorU += fluxo[i][j-1][0];
                         valorV += fluxo[i][j-1][1];
                     }
                     if(j + 1 < colunas){
                         ++numeroMedia;
                         valorU += fluxo[i][j+1][0];
                         valorV += fluxo[i][j+1][1];
                     }
                     //CALCULANDO MEDIA
                     valorU /= numeroMedia;
                     valorV /= numeroMedia;
                     */
                     int p = (int)(frameX[i][j] * fluxoMedio[i][j][0] + 
                             frameY[i][j] * fluxoMedio[i][j][1] + 
                             frame1T[i][j]);
                     int d = lambda + frameX[i][j]*frameX[i][j] + frameY[i][j]*frameY[i][j];
                     float uAntigo = fluxo[i][j][0];
                     float vAntigo = fluxo[i][j][0] ;
                     fluxo[i][j][0] = (int)fluxoMedio[i][j][0]  - frameX[i][j] *( p / d );
                     fluxo[i][j][1] = (int)fluxoMedio[i][j][1]  - frameY[i][j] *( p / d );
                     soma  += pow(uAntigo - fluxo[i][j][0],2) + pow(vAntigo - fluxo[i][j][1],2)  ;
                 } 
             } 
         }while(soma/numeroPixels >= kMax*kMax); //<>//
         return fluxo;
    }

}