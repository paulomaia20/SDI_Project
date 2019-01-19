class Thunder {
  
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

     strokeWeight(3); //bolt is a little thicker than a line
     stroke(0); 
     fill(255); //Falta mudar para a cor da partícula 
     
     while(ypos<height){//to bottom of screen
     endX = xpos + int(random(-4,4)); //x-value varies
     endY = ypos + 1;    //y just goes up
     line(xpos,ypos,endX,endY);//draw a tiny segment
     xpos = endX;  //then x and y are moved to the 
     ypos = endY;  //end of the segment and so on
     
   }
 



  }

}
