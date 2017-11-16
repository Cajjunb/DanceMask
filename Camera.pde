import processing.video.*;
// Importando biblioteca de video

// DECLARACAO DA CLASSE DE CAMERA QUE TRATA E FAZ INTERFACE COM OUTROS MODULOS
class cameraInput {
  //Camera Objeot
  Capture cameraPrincipal;
  //Camera Objeot
  PImage frameAnterior;
  IntList movimentoDetectado;
  PImage frame1;
  PImage frame2;
  PImage setaUp;
  PImage setaUpRight;
  PImage setaUpLeft;  
  PImage setaDown;
  PImage setaDownRight;
  PImage setaDownLeft; 
  PImage setaLeft;
  PImage setaRight;

  int frame1INT[][] ;
  int frame2INT[][] ;
  float fluxo[][][] ;
  float fluxoAmbiente[][][] ;

  private final int LIMITE_MIN_X =  1;
  private final int LIMITE_MIN_Y = 1;

  public OpencvInterface interfaceCV;
  DanceMask ambiente;

  // Construtor, incializa a camera e verifica se eh possivel ser utilizado
  cameraInput(DanceMask ambiente) {
    this.cameraPrincipal = new Capture(ambiente, 320, 240, 30);
    this.cameraPrincipal.start();
    this.frameAnterior = createImage(this.cameraPrincipal.width, this.cameraPrincipal.height, RGB);
    this.frame1 = createImage(this.cameraPrincipal.width, this.cameraPrincipal.height, RGB);
    this.frame2 = createImage(this.cameraPrincipal.width, this.cameraPrincipal.height, RGB);
    this.movimentoDetectado = new IntList();
    //Setando o ambiente
    this.ambiente = ambiente;
    //Inicializando o OpenCV
    this.interfaceCV = new OpencvInterface(this.ambiente, 240, 320);
  }


  void calculaFluxoOpenCV() {
    this.frame1.copy(this.cameraPrincipal, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height);
    this.frame1.updatePixels();
    this.cameraPrincipal.read();
    delay(10);
    this.frame2.copy(this.cameraPrincipal, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height);
    this.frame2.updatePixels();
    this.cameraPrincipal.read();
    this.frame1.filter(GRAY);    
    this.frame2.filter(GRAY);
    this.frame1.loadPixels();
    this.frame2.loadPixels();
    this.fluxo = this.interfaceCV.calculaHornSchunck(this.frame1,this.frame2);
    return ;
  }  

  void calculaFluxoOpenCV(int rowsAmbiente, int colsAmbiente) {
    this.frame1.copy(this.cameraPrincipal, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height);
    this.frame1.updatePixels();
    this.cameraPrincipal.read();
    delay(10);
    this.frame2.copy(this.cameraPrincipal, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height);
    this.frame2.updatePixels();
    this.cameraPrincipal.read();
    this.frame1.filter(GRAY);    
    this.frame2.filter(GRAY);
    this.frame1.loadPixels();
    this.frame2.loadPixels();
    float[][][][] fluxo = this.interfaceCV.calculaHornSchunck(this.frame1, this.frame2, rowsAmbiente, colsAmbiente);
    this.fluxo = fluxo[0];
    this.fluxoAmbiente = fluxo[1];
   return ;
  }    



  //Mostra FLuxo
  void displayFluxo() {
    // cor auxiliar 
    //PRINTANDO A REPRESENTACAO
    color c;
    tint(255,30);
    for (int i = 0; i < this.cameraPrincipal.height; i+=20) {
      for (int j = 0; j < this.cameraPrincipal.width; j+=20) {
        float valorU      = fluxo[i][j][0];
        float valorV      = fluxo[i][j][1];
        //             if(this.opencvProcessador != null){
        //                 if(this.opencvProcessador.getFlowAt(i,j)!= null)
        if (valorU != 0 && valorV != 0 && abs(valorU)> LIMITE_MIN_X && abs(valorV) > LIMITE_MIN_Y  ) {
          // Calculando o angulo para ser mostrado, levamos em conta se o numero passou de -1 e 1
          float angulo = asin(valorU/sqrt(valorU*valorU+valorV*valorV))+PI/2;
          int cor = 0;
          if ( angulo < 0 )
            angulo += 2*PI;
          else if (angulo > 2*PI)
            angulo -= 2*PI;
          if (angulo > 0  && angulo <= 2*PI/8)
            cor =(#22b14c);
          else if (angulo > 2*PI/8  && angulo <= 2*2*PI/8 )
            cor =(#b5e61d);
          else if (angulo > 2*2*PI/8  && angulo <= 3*2*PI/8)
            cor =(#FF0000);
          else if (angulo > 3*2*PI/8  && angulo <= 4*2*PI/8 )
            cor =(#99d9ea);
          else if (angulo > 4*2*PI/8  && angulo <= 5*2*PI/8 )
            cor =(#a349a4);
          else if (angulo > 5*2*PI/8  && angulo <= 6*2*PI/8 )
            cor =(#ffaec9);
          else if (angulo > 6*2*PI/8  && angulo <= 7*2*PI/8 )
            cor =(#0000FF);
          else if (angulo > 7*2*PI/8  && angulo <= 2*PI )
            cor =(#ff00ff);
          stroke(000);
          point(j, i);
        }
      }
    }
  }
  //Mostra FLuxo
  void displayFluxoBackgroundAprox(int ScreenWidth, int ScreenHeight, PImage background) {
    // cor auxiliar 
    //PRINTANDO A REPRESENTACAO
    blendMode(BLEND);
    for (int i = 0; i < this.cameraPrincipal.height; ++i) {
      for (int j = 0; j < this.cameraPrincipal.width; ++j) {
        float valorU      = fluxo[i][j][0];
        float valorV      = fluxo[i][j][1];
        //             if(this.opencvProcessador != null){
        //                 if(this.opencvProcessador.getFlowAt(i,j)!= null)
        if (valorU != 0 && valorV != 0 && abs(valorU)> LIMITE_MIN_X && abs(valorV) > LIMITE_MIN_Y  ) {
            // Calculando o angulo para ser mostrado, levamos em conta se o numero passou de -1 e 1
           int jAux = (ScreenWidth * j/ cameraPrincipal.width );
           int iAux = (ScreenHeight * i/ cameraPrincipal.height);
           color c = background.get(jAux,iAux);
           stroke(c);
           point(jAux, iAux);
           //ellipse(jAux,iAux,2,2)[iAux*cameraPrincipal.width+jAux];   
        }
      }
    }
  }
  
  //Mostra FLuxo
  void displayFluxoBackground(int ScreenWidth, int ScreenHeight, PImage background) {
    int fator = ScreenHeight/this.cameraPrincipal.height;
    // cor auxiliar 
    //PRINTANDO A REPRESENTACAO
    blendMode(BLEND);
    for (int i = 0; i < this.cameraPrincipal.height; ++i) {
      for (int j = 0; j < this.cameraPrincipal.width; ++j) {
        float valorU      = fluxo[i][j][0];
        float valorV      = fluxo[i][j][1];
        //             if(this.opencvProcessador != null){
        //                 if(this.opencvProcessador.getFlowAt(i,j)!= null)
        if (valorU != 0 && valorV != 0 && abs(valorU)> LIMITE_MIN_X && abs(valorV) > LIMITE_MIN_Y  ) {
            // Calculando o angulo para ser mostrado, levamos em conta se o numero passou de -1 e 1
          int jAux = (ScreenWidth * j/ cameraPrincipal.width );
          int iAux = (ScreenHeight * i/ cameraPrincipal.height);
          PImage c = background.get(jAux,iAux,fator,fator);
          image(c,jAux,iAux);   
        }
      }
    }
  }


  //Mostra FLuxo
  void displayFluxoCorMedia(int ScreenWidth, int ScreenHeight, int deslocamento) {
    // cor auxiliar 
    //PRINTANDO A REPRESENTACAO
    blendMode(BLEND);
    int r,g,b;
    for (int i = 0; i < this.cameraPrincipal.height; ++i) {
      for (int j = 0; j < this.cameraPrincipal.width; ++j) {
        r = 0;
        g = 0;
        b = 0;
        int cor = 0;
        float valorU      = fluxo[i][j][0];
        float valorV      = fluxo[i][j][1];
        //             if(this.opencvProcessador != null){
        //                 if(this.opencvProcessador.getFlowAt(i,j)!= null)
        if (valorU != 0 && valorV != 0 && abs(valorU)> LIMITE_MIN_X && abs(valorV) > LIMITE_MIN_Y  ) {
            // Calculando o angulo para ser mostrado, levamos em conta se o numero passou de -1 e 1
           int jAux = (ScreenWidth * j/ cameraPrincipal.width );
           int iAux = (ScreenHeight * i/ cameraPrincipal.height);
           for(int k = 0; k <4 ; k++){
               if(k == 0)
                   cor = get((jAux+1),iAux) ;
               else if(k == 1)
                   cor = get((jAux-1),iAux) ;    
               else if(k == 2)
                   cor = get(jAux,(iAux+1)) ;   
               else if(k == 3)   
                   cor = get(jAux,(iAux-1)) ;
               r   += (int)((cor>>16)& 0xFF) / 4 - deslocamento;
               g   += (int)(((cor<<8)>>16)& 0xFF) / 4 - deslocamento;
               b   += (int)(((cor<<16)>>16)& 0xFF ) / 4 -deslocamento;
           }
           stroke(r,g,b);
           point(jAux, iAux);
           //ellipse(jAux,iAux,2,2);   
        }
      }
    }
  }


  //Mostra FLuxo
  void displayFluxo(int rowsAmbiente, int colsAmbiente) {
    pushMatrix();
    translate(this.frame2.width, 0);
    scale(-1, 1); // You had it right!
    image(this.frame2, 0, 0);
    popMatrix();
    //image(this.frame2,0,0);     //<>//
    //PRINTANDO A REPRESENTACAO
    for (int i = 0; i <this.cameraPrincipal.height; i++) {
      for (int j = 0; j < this.cameraPrincipal.width; ++j) {
        float valorU      = fluxo[i][j][0];
        float valorV      = fluxo[i][j][1];
        if (valorU != 0 && valorV != 0 && abs(valorU)> LIMITE_MIN_X && abs(valorV) > LIMITE_MIN_Y  ) {
          // Calculando o angulo para ser mostrado, levamos em conta se o numero passou de -1 e 1
          float angulo = asin(valorU/sqrt(valorU*valorU+valorV*valorV))+PI/2;
          int cor = 0;
          if ( angulo < 0 )
            angulo += 2*PI;
          else if (angulo > 2*PI)
            angulo -= 2*PI;
          if (angulo > 0  && angulo <= 2*PI/8)
            cor =(#22b14c);
          else if (angulo > 2*PI/8  && angulo <= 2*2*PI/8 )
            cor =(#b5e61d);
          else if (angulo > 2*2*PI/8  && angulo <= 3*2*PI/8)
            cor =(#FF0000);
          else if (angulo > 3*2*PI/8  && angulo <= 4*2*PI/8 )
            cor =(#99d9ea);
          else if (angulo > 4*2*PI/8  && angulo <= 5*2*PI/8 )
            cor =(#a349a4);
          else if (angulo > 5*2*PI/8  && angulo <= 6*2*PI/8 )
            cor =(#ffaec9);
          else if (angulo > 6*2*PI/8  && angulo <= 7*2*PI/8 )
            cor =(#0000FF);
          else if (angulo > 7*2*PI/8  && angulo <= 2*PI )
            cor =(#ff00ff);
          stroke(cor);
          point((this.frame2.width) - j, i);
        }
      } //<>//
    } //<>//
    for (int i = 0; i < rowsAmbiente; ++i) {
      for (int j = 0; j < colsAmbiente; ++j) {
        if (fluxoAmbiente[i][j][0] != 0 && fluxoAmbiente[i][j][1]  != 0 && abs(fluxoAmbiente[i][j][0])> LIMITE_MIN_X && abs(fluxoAmbiente[i][j][1]) > LIMITE_MIN_Y  ) {
          float angulo = asin(fluxoAmbiente[i][j][0]/sqrt(fluxoAmbiente[i][j][0]*fluxoAmbiente[i][j][0]+fluxoAmbiente[i][j][1]*fluxoAmbiente[i][j][1]));  
          if ( angulo < 0)
            angulo += 2*PI;
          if (angulo > 0 && angulo <= 2*PI/8)
            fill(#000000);
          else if (angulo > 2*PI/8 && angulo <= 2*2*PI/8)
            fill(#CC0000);
          else if (angulo > 2*2*PI/8 && angulo <= 3*2*PI/8)
            fill(#FF0000);
          else if (angulo > 3*2*PI/8 && angulo <= 4*2*PI/8)
            fill(#FF6666);
          else if (angulo > 4*2*PI/8 && angulo <= 5*2*PI/8)
            fill(#FFCCCC);
          else if (angulo > 5*2*PI/8 && angulo <= 6*2*PI/8)
            fill(#FFFFCC);
          else if (angulo > 6*2*PI/8 && angulo <= 7*2*PI/8)
            fill(#E5FFCC);
          else if (angulo > 7*2*PI/8 && angulo <= 2*PI)
            fill(#CCFFFF);
        } else {
          fill(#ffffff);
        }
        stroke(#FF0000);
        rect(320-j*10, i*10, 10, 10);
      }
    }
  }



  // Funcao que guarda o frame para ser calculado a diferenca depois
  void capturaFrame() {
    //this.frameAnterior = createImage(this.cameraPrincipal.width, this.cameraPrincipal.height, RGB);
  }
  // pega o pixel de movimento detectado tratado como fila
  int getPixelDetectado() {
    int retorno;  
    if (this.movimentoDetectado.size() > 0 ) {
      retorno = this.movimentoDetectado.get(0);
      this.movimentoDetectado.remove(0);
    } else {
      retorno = -1;
    }
    return retorno;
  }  
  // funcao que faz o output da camera e guarda o frames para o tracking da camera
  void desenhaCamera() {
    if (this.cameraPrincipal.available() == true) {  
      this.frameAnterior.copy(this.cameraPrincipal, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height, 0, 0, this.cameraPrincipal.width, this.cameraPrincipal.height);
      this.frameAnterior.updatePixels();
      this.cameraPrincipal.read();
    }
    image(this.cameraPrincipal, 400, 0);
    image(this.frameAnterior, 0, 0);
  }
  // funcao que faz o output da camera e guarda o frames para o tracking da camera. Versao que faz o resize de acordo com os argumentos
  void desenhaCamera(int largura, int altura) {
    if (this.cameraPrincipal.available() == true) {  
      this.frameAnterior.copy(this.cameraPrincipal, 0, 0, largura, altura, 0, 0, largura, altura);
      this.frameAnterior.updatePixels();
      this.cameraPrincipal.read();
    }
    this.frameAnterior.resize(largura,altura);
    image(this.frameAnterior, 0, 0);
  }
  //RETORNO DO FLUXO DA CAMERA 
  float[][][] getFluxo() {
    return this.fluxo;
  }
  //RETORNO DO FLUXO DE UM AMBIENTE CONVERTIDO DA CAMERA
  float[][][] getFluxoAmbiente() {
    return this.fluxoAmbiente;
  }
}