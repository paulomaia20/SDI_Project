class Thunder {
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
  
  int index_colour;
  int xpos; 
  float ypos; 
  float endY;
  int endX;
  int originalXPos;
  Timer timer; 

  Thunder(int xposition) {
    originalXPos=xposition; 
    xpos=xposition;
    ypos=0; 
    index_colour=int(random(0, 7));    
    timer = new Timer(300); 
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
   /*  if(ypos<height){//to bottom of screen
      endX = xpos + int(random(-4,4)); //x-value varies
      endY = ypos + 1;    //y just goes up
    // fill(filling);  } */ 
    
    
  }
  

  // Method to display
  void display() {
     filling=vectorColours[index_colour];
     fill(filling); //Falta mudar para a cor da partícula 
     strokeWeight(6); //bolt is a little thicker than a line
     stroke(filling); 
     
     
     while(ypos<height){//to bottom of screen
     endX = xpos + int(random(-4,4)); //x-value varies
     endY = ypos + 1;    //y just goes up
     line(xpos,ypos,endX,endY);//draw a tiny segment
     xpos = endX;  //then x and y are moved to the 
     ypos = endY;  //end of the segment and so on
     
   }
 



  }

}
