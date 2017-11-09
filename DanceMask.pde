import java.io.DataOutputStream;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;

int ALTURA = 400;
int LARGURA = 300;

//Variaveis globais no contexto do ambiente
PImage background;
OpticalFlow hsObjeto;
cameraInput camera;
PrintWriter FILE1;
PrintWriter FILE2;
float[][][] fluxoAmbiente;


void setup() {
    size(622,350);
    try{
        print("\t############### TRY!!#####################\n");
        //Instancia o controlador da camera 
        camera = new cameraInput(this);
    }catch(Exception e){
        print("\t############### EXCESSAO!!#####################");
    }
    //instanciando o vetor FLuxo
    fluxoAmbiente = new float[ALTURA][LARGURA][2];
    background = loadImage("texture.jpeg");
       
}

void draw(){
    background(background);   
    //camera.desenhaCamera();
    /*CALCULA o fluxo da imagem, depois retorna para ser usada para as células se movimentarem */
    camera.calculaFluxoOpenCV();
    fluxoAmbiente = camera.getFluxoAmbiente();
    
}