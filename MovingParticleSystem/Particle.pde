// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System
/*               R    G    B
   [0] vermelho  255  1    1
   [1] amarelo   255  225  30
   [2] laranja   255  175  15
   [3] verde     0    204  0
   [4] azul      51   204  204
   [5] roxo      190  116  202
   [6] cinzento  160  160  160
  */
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int index_colour;
  boolean touchedParticle;
  boolean touchedOnce;
  
  //==========Colors definition================
  color red=color(255,1,1);
  color yellow=color(255,225,30);
  color orange=color(255,175,15);
  color green=color(0,204,0);
  color blue=color(51,204,204);
  color purple=color(190,116,202);
  color grey=color(160,160,160);
  
  
  color [] vectorColours = {red, orange, yellow, green, blue, purple, grey};
  color filling;
  color thiscolor;

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    //velocity = new PVector(0,random(-600,5));
    velocity = new PVector(0,random(-500,4));
    position = l.get();
    lifespan = 99900.0;
    index_colour=int(random(0,7));    
    filling=vectorColours[index_colour];
    touchedParticle=false;
    touchedOnce=false;
  }
  
  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2.0; //<>//
  }
  
  // Method to display
  void display() {
    
    stroke(0,lifespan);
    strokeWeight(0);
    if (mouseOverCircle((int) position.x, (int) position.y, 15.0, 25.0)){ 
      if (!touchedOnce){        
        touchedOnce=true;
        touchedParticle=true; 
      }
      else
        touchedParticle=false; 
      fill(255,255, 255);
      lifespan=0;      
    }
    else {
      fill(filling,lifespan);
      touchedParticle=false;
    }
    ellipse(position.x,position.y,15,25);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  void setLifespan(int lifespan) {
    this.lifespan = lifespan;
  }
  
    // Method to get lifespan
  float getLifespan() {
    return this.lifespan; 
  }
  
  boolean mouseOverCircle(int x, int y, float diameter1, float diameter2) {
    return (dist(mouseX, mouseY, x, y) < (diameter1+diameter2));
  }
  
}
