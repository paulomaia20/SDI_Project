// The Nature of Code //<>//
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System
/*              R    G    B
 [0] red       239  51   64
 [1] yellow    243  207  85
 [2] orange    255  108  47
 [3] green     136  176  75
 [4] blue      87   140  169
 [5] purple    173  94   153
 [6] grey      129  131  135
 */
 
class Particle {
  //PShape drop;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int index_colour;
  boolean touchedParticle;
  boolean touchedOnce;
  int time_particle = millis();

  //==========Colors definition================
  color red=color(239, 51, 64);
  color yellow=color(243, 207, 85);
  color orange=color(255, 108, 47);
  color green=color(136, 176, 75);
  color blue=color(87, 140, 169);
  color purple=color(173, 94, 153);
  color grey=color(129, 131, 135);

  color [] vectorColours = {red, yellow, orange, green, blue, purple, grey};
  color filling;
  color thiscolor;
  int angle; 

  Particle(PVector l) {
    //drop = loadShape("drop.svg");
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(0, random(-500, 4));
    position = l.copy();
    lifespan = 99900.0;
    index_colour=int(random(0, 7));    
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
    lifespan -= 2.0;
  }

  // Method to display
  void display() {

    stroke(0, lifespan);
    strokeWeight(0);
    if (mouseOverCircle((int) position.x, (int) position.y, 15.0, 25.0)) { 
      if (!touchedOnce) {        
        touchedOnce=true;
        touchedParticle=true;
        changeBackground();
      } else
        touchedParticle=false; 
      fill(255, 255, 255);
      lifespan=0;
    } else {
      fill(filling, lifespan);
      touchedParticle=false;
    }
    ellipse(position.x, position.y, 15, 25);
    //shape(drop, position.x, position.y, 40, 40);
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

  void changeBackground()
  {

  background(filling, 0.1);
  }
}
