// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

ParticleSystem ps;
int time;
Cursor c; 

final int stateWaitBeforeProgram = 0;
final int stateNormalProgram = 1;
int state = stateWaitBeforeProgram;

void setup() {
  fullScreen();
  //size(800,600);
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
