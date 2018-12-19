class Cursor {
  int xposition;
  int yposition; 

  Cursor() {
  }

  // Method to display
  void display() {
    stroke(255);
    strokeWeight(0);
    fill(color(0, 0, 0));
    ellipse(xposition, yposition, 10, 10);
  }

  void update() {
    xposition=mouseX;
    yposition=mouseY;
  }

  void run() {
    update();
    display();
  }
}
