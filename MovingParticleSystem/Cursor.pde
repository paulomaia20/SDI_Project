import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

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

  void update(int xpos, int ypos) {
    xposition=xpos;
    yposition=ypos;
  }

  void run(int xpos, int ypos) {
    update(xpos, ypos);
    display();
  }
  
}
