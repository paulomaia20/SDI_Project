// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
ParticleSystem ps;
int time;
Cursor c; 
Capture video;
OpenCV opencv;
Rectangle[] faces;

final int stateWaitBeforeProgram = 0;
final int stateNormalProgram = 1;
int state = stateWaitBeforeProgram;

void setup() {
  fullScreen();
  //size(640,480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();

  ps = new ParticleSystem(new PVector(width/2,50));
  c = new Cursor();
  frameRate(300);
  smooth();

}
  
void draw() {
  
  if (state == stateWaitBeforeProgram) {
     background(255);
     textSize(20);
     textAlign(CENTER, CENTER);
     text ("Carrega no rato para iniciar o jogo", width/2, height/2);
     c.run();
 
}
else {
 background(255);
  translate(video.width,5);
  scale(-1,1);
  opencv.loadImage(video);
 
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  
    for (int i = 0; i < faces.length; i++) {
    //println(faces[i].x + "," + faces[i].y);
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
    mouseX = (faces[i].x+faces[i].width/2);
    mouseY = (faces[i].y+faces[i].height/2);
  }
  
  ps.origin.set(random(0,2000),0,0);  
  ps.addParticle();
  ps.run(); 
  

} 


}


void mousePressed() {
 
 
if (state == stateWaitBeforeProgram) {
 state=stateNormalProgram ;
}

} // func 

void captureEvent(Capture c) {
  c.read();
}
