class Cursor {
  int xposition;
  int yposition; 
  float r;    // radius

  Cursor(float tempR) {
    r = tempR;
  }

  // Method to display
  void display() {
    stroke(0);
    strokeWeight(0.5);
    fill(color(128,128,128));
    ellipse(xposition, yposition, r*2, r*2);
  }

  void update(int xpos, int ypos) {
    xposition=xpos;
    yposition=ypos;
  }

  void run(int xpos, int ypos) {
    update(xpos, ypos);
    display();
  }

  // A function that returns true or false based on
  // if the catcher intersects a raindrop
  boolean intersect(Particle p) {
    // Calculate distance
    float distance = dist(xposition, yposition, p.x, p.y); 

    // Compare distance to sum of radii
    if (distance < 2*r + p.r) { 
      return true;
    } else {
      return false;
    }
  }
}
