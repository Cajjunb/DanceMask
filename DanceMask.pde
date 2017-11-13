import java.io.DataOutputStream;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;

int ALTURA = 400;
int LARGURA = 300;

//Variaveis globais no contexto do ambiente
PImage background;
cameraInput camera;
PrintWriter FILE1;
PrintWriter FILE2;
float[][][] fluxoAmbiente;


void setup() {
    //Seta o tamanho da tela.
    //Tenta instanciar a camera se der 
    //instanciando o vetor FLuxo
    //Carrega imagem do background para ser a textura!
    size(640,480);
    frameRate(15);
    try{
        print("\t############### INSTANCIANDO CAMERA #####################\n");
        //Instancia o controlador da camera 
        camera = new cameraInput(this);
    }catch(Exception e){
        print("\t############### ERRO! NAO FOI POSSIVEL INSTANCIAR CAMERA!!#####################");
    }
    fluxoAmbiente = new float[ALTURA][LARGURA][2];
    background = loadImage("sand3.jpg");
}

void draw(){
    //Coloca o background
    //Calcula Movimento do contorno
    //Desenha na tela o vulto
    image(background,0,0);   
    camera.calculaFluxoOpenCV();
    camera.displayFluxoCorMedia();
    
}