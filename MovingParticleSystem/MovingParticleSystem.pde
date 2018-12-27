// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
ParticleSystem ps;
int timeClicked;
Cursor c; 
Capture video;
OpenCV opencv;
User u; 
Rectangle[] faces;
int elapsed_time; 
PShape svg, svg2;
final int stateWaitBeforeProgram = 0;
final int stateWaitAfterProgram = 2;
final int stateNormalProgram = 1;
int state = stateWaitBeforeProgram;
User newUser;
int id_user=1;

PrintWriter output;

void setup() {
  fullScreen();
  //size(640, 480);
  // video = new Capture(this, 640/2, 480/2);
  //opencv = new OpenCV(this, 640/2, 480/2);
  //opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  // video.start();
  /*TER AQUI UMA FUNÇÃO PARA IR BUSCAR O ÚLTIMO USER AO TXT*/

  newUser= new User(id_user);
  ps = new ParticleSystem(new PVector(width/2, 50), newUser);
  c = new Cursor();
  frameRate(30);
  smooth();
  svg = loadShape("male.svg");
  svg2 = loadShape("feet.svg");
  svg.disableStyle();

  svg.setFill(color(random(255))); 
  svg2.disableStyle();   

  svg2.setFill(color(0, 0, 0));
  
  // create a file in the sketch directory
  output = createWriter("statistics_user" + id_user +".txt");
}

void draw() {

  if (state == stateWaitBeforeProgram) {
    background(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text ("Carrega no rato para iniciar o jogo", width/2, height/2);
    c.run();
  } else if (state==stateNormalProgram) {
    background(255);
    //translate(video.width,5);
    //scale(-1,1);
    /*  svg.disableStyle();
     
     svg.setFill(color(random(255))); 
     svg.setStroke(color(255,255,20));
     shape(svg,width/2,height/2,width/2,height/2);
     svg2.disableStyle(); */

    //svg2.setStroke(color(255,255,20));
    shape(svg, width-width/12, height-height/8, width/16, height/8);
    //   shape(svg,mouseX,mouseY, width/16, height/8);
    fill(0);  //mudar para cor da partícula apanhada ?? pensar melhor ! 
    shape(svg2, width-width/12, height-height/8, width/16, height/8);

    /* opencv.loadImage(video);
     
     noFill();
     stroke(0, 255, 0);
     strokeWeight(3);
     Rectangle[] faces = opencv.detect();
     
     for (int i = 0; i < faces.length; i++) {
     //println(faces[i].x + "," + faces[i].y);
     //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
     mouseX = (faces[i].x+width/8);
     mouseY = (faces[i].y+height/8);
     } */


    ps.origin.set(random(0, 2000), 0, 0);  
    ps.addParticle();
    ps.run(); 

    textSize(20);
    textAlign(RIGHT, TOP);
    //text ("Elapsed time", width/2, height/2);
    elapsed_time=(millis()-timeClicked)/1000;
    text (elapsed_time, width/2, 0);

    // }

    if (elapsed_time>5) {
         
      state=stateWaitAfterProgram; 
      background(255);
      textSize(40);

      fill(0);

      textAlign(CENTER, CENTER);
      text("O jogo terminou", width/2, height/2);
      textAlign(LEFT, LEFT);

      textSize(20);
      // Mostrar estatísticas do utilizador
      text("Partículas vermelhas:", width/2, height/2-height/4);
      text(newUser.getColoursStatistics()[0], width/2+width/6, height/2-height/4);

      text("Partículas amarelas:", width/2, height/2-height/4-20);
      text(newUser.getColoursStatistics()[1], width/2+width/6, height/2-height/4-20);

      text("Partículas laranjas:", width/2, height/2-height/4-40);
      text(newUser.getColoursStatistics()[2], width/2+width/6, height/2-height/4-40);

      text("Partículas verdes:", width/2, height/2-height/4-60);
      text(newUser.getColoursStatistics()[3], width/2+width/6, height/2-height/4-60);

      text("Partículas azuis:", width/2, height/2-height/4-80);
      text(newUser.getColoursStatistics()[4], width/2+width/6, height/2-height/4-80);

      text("Partículas roxas:", width/2, height/2-height/4-100);
      text(newUser.getColoursStatistics()[5], width/2+width/6, height/2-height/4-100);

      text("Partículas cinzentas:", width/2, height/2-height/4-120);
      text(newUser.getColoursStatistics()[6], width/2+width/6, height/2-height/4-120);   
      
      write("Moving Particle System Statistics");
      output.println("Partículas vermelhas: " + (newUser.getColoursStatistics()[0]));
      output.println("Partículas amarelas: " + (newUser.getColoursStatistics()[1]));
      output.println("Partículas laranjas: " + (newUser.getColoursStatistics()[2]));
      output.println("Partículas verdes: "+ (newUser.getColoursStatistics()[3])); 
      output.println("Partículas azuis: " + (newUser.getColoursStatistics()[4]));  
      output.println("Partículas roxas: " + (newUser.getColoursStatistics()[5]));
      output.println("Partículas cinzentas: " + (newUser.getColoursStatistics()[6]));
      
      // finish writing data to the file
      output.flush();  
      output.close();
      
      //Restart and give a new score
      id_user++; 
      setup(); 
    }
  }  
}

void write(String str) {
  output.println(str);
}

void mousePressed() {

  if (state == stateWaitBeforeProgram) {
    state=stateNormalProgram ;
    timeClicked=millis();
  }
  

  if (state == stateWaitAfterProgram) {
    state=stateNormalProgram ;
    timeClicked=millis(); 
    //Reset variables!
  }
} 

void captureEvent(Capture c) {
  c.read();
}
