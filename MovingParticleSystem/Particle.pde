// Simple Particle System //<>// //<>// //<>// //<>//
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
  PShape drop;
  PVector position;
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
  float r;      // Radius of raindrop
  float x, y; //Position of the raindrop 
  float speed;  // Speed of raindrop
  float opacity;
  boolean caught; 


  Particle() {

    r = 12;                   // All raindrops are the same size
    x = random(width);       // Start with a random x location
    y = -r*4;                // Start a little above the window
    speed = random(1, 10);    // Pick a random speed
    index_colour=int(random(0, 7));    
    filling=vectorColours[index_colour];
    opacity=255;
    touchedOnce=false;
  }
  
 Particle(int index_colour) {

    r = 12;                   // All raindrops are the same size
    x = random(width);       // Start with a random x location
    y = -r*4;                // Start a little above the window
    speed = random(1, 10);    // Pick a random speed
    this.index_colour=index_colour;
    filling=vectorColours[index_colour];
    opacity=255;
    touchedOnce=false;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    y += speed;
  }

  // Method to display
  void display() {

    strokeWeight(0);
    fill(filling, opacity);

    //DROP SHAPED:
    noStroke();
    for (int i = 2; i < r; i++ ) {
      ellipse(x, y + i*4, i*2, i*2);
    }
  }

  void updateOpacity() {
    if(opacity>0)
      opacity=opacity-(speed*2);
  }

  void setCaughtState(boolean state) {
    caught=state;
  }

  boolean getCaughtState() {
    return caught;
  }

  float getOpacity()
  {
    return opacity;
  }

  boolean getTouchedOnce(){
    return touchedOnce;
  }
  // Check if it hits the bottom
  boolean reachedBottom() {
    // If we go a little beyond the bottom
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }


  // If the drop is caught
  void caught() {
    // Stop it from moving by setting speed equal to zero
    speed = 0; 
    // Set the location to somewhere way off-screen
    y = -1000;
    touchedOnce=true;
  }
}
