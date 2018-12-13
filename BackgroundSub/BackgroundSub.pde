import processing.video.*;
import gab.opencv.*;
import java.awt.*;

int numPixels;
int[] backgroundPixels;
Capture video;
OpenCV opencv;
boolean alreadyPressed;

void setup() {
 // Change size to 320 x 240 if too slow at 640 x 480
 size(640,480); 
 
 video = new Capture(this, width, height);
 opencv = new OpenCV(this, width, height);
 opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
 video.start();
 numPixels = video.width * video.height;
 // Create array to store the background image
 backgroundPixels = new int[numPixels];
 // Make the pixels[] array available for direct manipulation
 loadPixels();
}

void draw() {
 if (video.available()) {
   video.read(); // Read a new video frame
   video.loadPixels(); // Make the pixels of video available
   // Difference between the current frame and the stored background
   int presenceSum = 0;
   for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
     // Fetch the current color in that location, and also the color
     // of the background in that spot
     color currColor = video.pixels[i];
     color bkgdColor = backgroundPixels[i];
     // Extract the red, green, and blue components of the current pixel’s color
     int currR = (currColor >> 16) & 0xFF;
     int currG = (currColor >> 8) & 0xFF;
     int currB = currColor & 0xFF;
     // Extract the red, green, and blue components of the background pixel’s color
     int bkgdR = (bkgdColor >> 16) & 0xFF;
     int bkgdG = (bkgdColor >> 8) & 0xFF;
     int bkgdB = bkgdColor & 0xFF;
     // Compute the difference of the red, green, and blue values
     int diffR = abs(currR - bkgdR);
     int diffG = abs(currG - bkgdG);
     int diffB = abs(currB - bkgdB);
     // Add these differences to the running tally
     presenceSum += diffR + diffG + diffB;
     // Render the difference image to the screen
     //pixels[i] = color(diffR, diffG, diffB);
     // The following line does the same thing much faster, but is more technical
     pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
   }
   
    updatePixels(); // Notify that the pixels[] array has changed
    
    opencv.getOutput();
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    opencv.loadImage(video);
    Rectangle[] faces = opencv.detect();
    if (alreadyPressed){
    opencv.threshold(100);
    opencv.dilate();
    opencv.invert();
    opencv.getOutput();
    updatePixels();
    }
        
      for (int i = 0; i < faces.length; i++) {
   // println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
 
   
   
   //println(presenceSum); // Print out the total amount of movement
   
   //image(opencv.getOutput(),0,0);
   
 }
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame’s pixels into it.
void keyPressed() {
 alreadyPressed=true;
 video.loadPixels();
 arrayCopy(video.pixels, backgroundPixels);
 
}
