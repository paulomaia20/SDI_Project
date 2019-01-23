import processing.video.*;  //<>//
import java.awt.Rectangle;
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
import oscP5.*;
import netP5.*;

//OPEN SOUND CONTROL
OscP5 oscP5;
NetAddress dest;

//States
final int stateWaitBeforeProgram = 0;
final int stateWaitAfterProgram = 2;
final int stateNormalProgram = 1;
final int statePauseProgram=3; 
int state = stateWaitBeforeProgram;

//Kinect-related variables
final int RADIUS=20; //Cursor radius 
Kinect kinect;
int timeClicked, elapsed_time, elapsed_time1;
Cursor c; 
ArrayList <SkeletonData> bodies;
int kinect_x_pos, kinect_y_pos;

final int TOTAL_PARTICLE=100;

//User variables
User newUser;
int id_user=1;
int total_caught=0;

//Others 
bouncyWord title;
PrintWriter output;
Particle[] particles;
Timer timer, noPlayTimer, showPlayButtonTimer;        // One timer object
int totalParticles,totalThunders,thunderCountdown;    // totalDrops
PFont mono;
//boolean caughtState=false; 
//boolean touchedOnce=false;
boolean restart=false;
boolean startgame=false; 
boolean finish_game;

int thunderNum1;
int thunderNum2;
Thunder thunders;

//==========Colors definition================
color red=color(239, 51, 64);
color yellow=color(243, 207, 85);
color orange=color(255, 108, 47);
color green=color(136, 176, 75);
color blue=color(87, 140, 169);
color purple=color(173, 94, 153);
color grey=color(129, 131, 135);

color [] vectorColours = {red, yellow, orange, green, blue, purple, grey};

PShape screenImage;
PShape [] arrayImages = new PShape[5];

PShape button, button_restart; 
PShape [] arrayShapes = new PShape[7];
int idx_screenimage; 

PShape testimg; 

void setup() {
    
  fullScreen();

  // Load rain images for start menu
  for (int i = 0; i < arrayImages.length; i++) {
    arrayImages[i] = loadShape("rain0" + i + ".svg");
  }
  
  //Load body shapes for main menu
  // arrayShapes = {full_body, head, left_arm, body, right_arm, left_leg, right_leg}
  for (int i = 0; i < arrayShapes.length; i++) {
    arrayShapes[i] = loadShape("bodypart0" + i + ".svg"); 
  }
    
  // start oscP5, listening for incoming messages at port 9000 
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
  sendOsc(555);

  //Set standard font
  mono = createFont("FiraSans-Regular.ttf", 32);
  textFont(mono);

  //Set bouncy title
  title = new bouncyWord("Raindrop", width/2);

  // Create new user
  newUser= new User(id_user);
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();
  c = new Cursor(RADIUS); //Cursor with radius RADIUS

  frameRate(300);
  //smooth();
  
  //Load button for main menu
  button = loadShape("button.svg");
  button_restart = loadShape("restart_game_button.svg");
  
  testimg= loadShape("rain01.svg");


  // create a file in the sketch directory
  int d = day();  // Values from 1 - 31
  output = createWriter("statistics_user" + id_user + "_day" + d + ".txt");

  particles = new Particle[TOTAL_PARTICLE];  // Create 50 spots in the array - Variar de acordo com o que decidirmos. Tem de ter um máximo de particulas, funçao do tempo da simulação
  timer = new Timer(600);  // Create a timer that goes off every X milliseconds. Number of particles is a function of the timer. 

  // timer to count the time since the last time the user caught one drop
  showPlayButtonTimer = new Timer(0);  
  showPlayButtonTimer.start();
  noPlayTimer=new Timer(10000);
  
  noCursor();   // Hide the cursor
  
  //Initialize game-related variables
  finish_game=false;
  totalParticles=0;
  totalThunders=0;
  thunderCountdown=0;
  idx_screenimage=0; 
}

void draw() {  

  int s = second();  // Values from 0 - 59
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23

  /*if (bodies.size()!=0) {
    kinect_x_pos=int(bodies.get(0).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x*width);
    kinect_y_pos=int(bodies.get(0).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y*height);
    c.run(kinect_x_pos,kinect_y_pos);
  }*/
  
  if (bodies.size()>=2)
      state=statePauseProgram; 
  
  // IF KINECT IS NOT ON
  kinect_x_pos=mouseX;
  kinect_y_pos=mouseY; 
  
  if (state == stateWaitBeforeProgram) {
    background(255);    
    switch(idx_screenimage){
      case 0:
        idx_screenimage = 1;
        break;
      case 1:
        idx_screenimage = 2;
        break;
      case 2:
        idx_screenimage = 3;
        break;
      case 3:
        idx_screenimage = 4;
        break;
      case 4:
        idx_screenimage = 0;
        break;
    }   

    shape(arrayImages[idx_screenimage], 0, 0, width, height);

    fill(255); 
    textAlign(CENTER);
    textSize(50);
    title.draw();
    
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Passa o cursor por cima do botão para iniciar o jogo.", width/2, height/2+300);


    if (showPlayButtonTimer.isFinished()) {  
          // Place button
    shape(button, width/2-width/8, height/2, 250*2, 75*2);
      //Check if cursor is over the button
     
    startgame = checkMouseHoverAction(width/2-width/8, height/2, kinect_x_pos, kinect_y_pos, 250*2, 75*2); //Diria para começar o noPlayTimer aqui. Esta ação podia ser um booleano
      
      if(startgame)
          noPlayTimer.start(); 
      fill(color(128,128,128));
    }

    c.run(kinect_x_pos,kinect_y_pos);
    
  } else if (state == stateNormalProgram) {
    
    background(255);
    
    //Add Score to the corner
    textSize(30);
    fill(0);
    text("Score:", width-150,20);
    text(str(total_caught), width-40, 20);
    
    noStroke();
    shape(arrayShapes[0], width-width/12, height-height/5, width/10, height/5); 
    int maximum =max(newUser.coloursStatistics);
    int max_index=0;
    for (int i=0; i<7; i++){
      if(newUser.coloursStatistics[i]==maximum)
        max_index=i;
    } 
    if(maximum!=0){
      switch(max_index){
        case 0: // red
        case 1: // yellow
        case 2: // orange
        case 5: // purple
          arrayShapes[3].disableStyle(); // body
          fill(vectorColours[max_index]);
          noStroke();
          shape(arrayShapes[3], width-width/12, height-height/5, width/10, height/5);
          break;
        case 4: // blue
        case 6: // grey
          arrayShapes[1].disableStyle(); // head
          fill(vectorColours[max_index]);
          noStroke();
          shape(arrayShapes[1], width-width/12, height-height/5, width/10, height/5);
          break;
        case 3: // green
          fill(vectorColours[max_index]);
          arrayShapes[2].disableStyle(); // limbs
          noStroke();
          shape(arrayShapes[2], width-width/12, height-height/5, width/10, height/5);                  
          arrayShapes[4].disableStyle();
          noStroke();
          shape(arrayShapes[4], width-width/12, height-height/5, width/10, height/5);
          arrayShapes[5].disableStyle();
          noStroke();
          shape(arrayShapes[5], width-width/12, height-height/5, width/10, height/5);                  
          arrayShapes[6].disableStyle();
          noStroke();
          shape(arrayShapes[6], width-width/12, height-height/5, width/10, height/5);
          break;
      }  
    } 
   
    c.run(kinect_x_pos,kinect_y_pos);
    // Add more particles to the particle vector
    if (timer.isFinished()) {     
      if (thunderCountdown==10) {
        int thunderX=(int) random(width);
        thunders = new Thunder(thunderX);
        particles[totalParticles] = new Particle(thunders.index_colour);
        // Increment totalParticles
        totalParticles ++ ; 
        timer.start();
        thunderCountdown=0;
        totalThunders ++; 
      } else {
        particles[totalParticles] = new Particle();
        // Increment totalParticles
        totalParticles++; 
        timer.start();
        thunderCountdown++;
      }
    }
       
    //println(totalParticles);
    //}
    if (totalParticles>=TOTAL_PARTICLE)
      finish_game=true;
    
    // Move and display all drops
    if (!finish_game) {
          
      if (thunders!=null)
        thunders.display(); 

      for (int i = 0; i < totalParticles; i++) {
        particles[i].update();
        particles[i].display();
        if (particles[i].getCaughtState()==true) {
          particles[i].updateOpacity();        
          
          if ((particles[i].getOpacity()<=50) && (!particles[i].getTouchedOnce())) {
            particles[i].caught();
            noPlayTimer.start();
            (newUser.getColoursStatistics())[particles[i].index_colour]++;
            sendOsc(particles[i].index_colour);     
            total_caught++;
          }
        }
        if (c.intersect(particles[i])) {
          particles[i].setCaughtState(true);      
          
        }
      }
    }
    
    if (noPlayTimer.isFinished() || finish_game) {
      state=stateWaitAfterProgram;
      elapsed_time=(millis()-timeClicked)/1000;
      println("Acabou");
    }
    
  } else if (state == stateWaitAfterProgram) {
    
    showStats(s, m, h);
    c.run(kinect_x_pos,kinect_y_pos);

    // Place button
    shape(button_restart, width/2-width/10, height/2+height/4, 370,100);

    //Check if cursor is over the button
    restart = checkMouseHoverAction_afterEnd(width/2-width/10, height/2+height/8, kinect_x_pos, kinect_y_pos, 370,100);

    if (restart)
    {    
      //Restart and reset variables - user id and particles array 
      id_user++; 
      newUser = new User(id_user); 
      totalParticles = 0;
      noPlayTimer=new Timer(10000); //timer to count the time since the last time the user caught one drop      
      noPlayTimer.start(); 
      finish_game=false;
      state=stateWaitBeforeProgram;
      showPlayButtonTimer.setTime(3000);
      showPlayButtonTimer.start();
      synchronized(bodies) {
        for (int i=bodies.size() -1; i>=0; i--)
        {     
            bodies.remove(i);  
        }
      }
      print(bodies.size());
    }
  }  
  else if (state == statePauseProgram)  
  {
  background(255); 
  textSize(30);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Apenas é permitido um jogador de cada vez.", width/2, height/2);
  text("Está a ser detetado mais do que um jogador. ", width/2, height/2-height/8);     
  if (bodies.size()<2)
    state=stateNormalProgram;
  }
  
}


void showStats(int s, int m, int h) {

  background(25,45,70);

  textSize(65);
  fill(255, 250, 250);
  textAlign(CENTER, CENTER);
  text("O jogo terminou", width/2, height/12);

  int xpos_particle_title=width/2-width/10; 
  int ypos_particle_title=height/2; 
  int xpos_particle_title_amount=width/2+width/10;
  int ypos_particle_title_amount=height/2; 

  textAlign(LEFT, LEFT);
  textSize(40);
  text("Tempo de jogo (s):", xpos_particle_title, ypos_particle_title-300);
  text(elapsed_time, xpos_particle_title_amount, ypos_particle_title_amount-300);
  textSize(30);
  // Mostrar estatísticas do utilizador
  fill (245, 95 , 95);
  rect(0,ypos_particle_title_amount+140, width ,60);
  fill(0);
  text("Partículas vermelhas:", xpos_particle_title, ypos_particle_title+180);
  text(newUser.getColoursStatistics()[0], xpos_particle_title_amount, ypos_particle_title_amount+180);
  fill (250, 160, 85);
  rect(0,ypos_particle_title_amount+80, width ,60);
  fill(0);
  text("Partículas laranjas:", xpos_particle_title, ypos_particle_title+120);
  text(newUser.getColoursStatistics()[2], xpos_particle_title_amount, ypos_particle_title_amount+120);  
  fill (243, 207, 85);
  rect(0,ypos_particle_title_amount+20, width,60);
  fill(0);
  text("Partículas amarelas:", xpos_particle_title, ypos_particle_title+60);
  text(newUser.getColoursStatistics()[1], xpos_particle_title_amount, ypos_particle_title_amount+60);  
  fill (136, 176, 75);
  rect(0,ypos_particle_title_amount-40, width, 60);
  fill(0);
  text("Partículas verdes:", xpos_particle_title, ypos_particle_title-0);
  text(newUser.getColoursStatistics()[3], xpos_particle_title_amount, ypos_particle_title_amount-0);
  fill (14,180,195);
  rect(0,ypos_particle_title_amount-100, width ,60);
  fill(0);
  text("Partículas azuis:", xpos_particle_title, ypos_particle_title-60);
  text(newUser.getColoursStatistics()[4], xpos_particle_title_amount, ypos_particle_title_amount-60);
  fill (173, 94, 153);
  rect(0,ypos_particle_title_amount-160, width ,60);
  fill(0);
  text("Partículas roxas:", xpos_particle_title, ypos_particle_title-120);
  text(newUser.getColoursStatistics()[5], xpos_particle_title_amount, ypos_particle_title_amount-120);
  fill (129, 131, 135);
  rect(0,ypos_particle_title_amount-220, width ,60);
  fill(0);
  text("Partículas cinzentas:", xpos_particle_title, ypos_particle_title-180);
  text(newUser.getColoursStatistics()[6], xpos_particle_title_amount, ypos_particle_title_amount-180);

  String formatStr = "%-25s %-15s";

  output.println("id " + id_user);
  output.println("início às " + h + ":" + m + ":" + s);
  output.println("\n");
  output.println(String.format(formatStr, "partículas vermelhas", (newUser.getColoursStatistics()[0])));
  output.println(String.format(formatStr, "partículas amarelas", (newUser.getColoursStatistics()[1])));
  output.println(String.format(formatStr, "partículas laranjas", (newUser.getColoursStatistics()[2])));
  output.println(String.format(formatStr, "partículas verdes", (newUser.getColoursStatistics()[3])));
  output.println(String.format(formatStr, "partículas azuis", (newUser.getColoursStatistics()[4])));
  output.println(String.format(formatStr, "partículas roxas", (newUser.getColoursStatistics()[5])));
  output.println(String.format(formatStr, "partículas cinzentas", (newUser.getColoursStatistics()[6])));

  // finish writing data to the file
  output.flush();  
  output.close();
}


boolean checkMouseHoverAction(int rectXPos, int rectYpos, int xpos, int ypos, int rectWidth, int rectHeight) {
  if (xpos >= rectXPos && xpos <= rectXPos+rectWidth && 
    ypos >= rectYpos && ypos <= rectYpos+rectHeight && state == stateWaitBeforeProgram ) {
    state=stateNormalProgram;
    timer.start();             // Starting the timer
    timeClicked=millis();
    return true;
  }
  return false;
}


boolean checkMouseHoverAction_afterEnd(int rectXPos, int rectYpos, int xpos, int ypos, int rectWidth, int rectHeight) {
  if (xpos >= rectXPos && xpos <= rectXPos+rectWidth && 
    ypos >= rectYpos && ypos <= rectYpos+rectHeight && state == stateWaitAfterProgram) {
    state=stateNormalProgram;
    timeClicked=millis();
    sendOsc(777);
    return true;
  }
  return false;
}

// Kinect lib

void drawPosition(SkeletonData _s) {
  noStroke();
  fill(0, 100, 255);
  String s1 = str(_s.dwTrackingID);
  text(s1, _s.position.x*width/2, _s.position.y*height/2);
}

void drawSkeleton(SkeletonData _s) {
  // Body
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_HEAD, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
    Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
    Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SPINE, 
    Kinect.NUI_SKELETON_POSITION_HIP_CENTER);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
    Kinect.NUI_SKELETON_POSITION_HIP_LEFT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
    Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
    Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);

  // Left Arm
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
    Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT, 
    Kinect.NUI_SKELETON_POSITION_WRIST_LEFT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
    Kinect.NUI_SKELETON_POSITION_HAND_LEFT);

  // Right Arm
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);

  // Left Leg
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
    Kinect.NUI_SKELETON_POSITION_KNEE_LEFT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_KNEE_LEFT, 
    Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT, 
    Kinect.NUI_SKELETON_POSITION_FOOT_LEFT);

  // Right Leg
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_HIP_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT);
  DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT);
}


void DrawBone(SkeletonData _s, int _j1, int _j2) 
{
  noFill();
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
    line(_s.skeletonPositions[_j1].x*width/2, 
      _s.skeletonPositions[_j1].y*height/2, 
      _s.skeletonPositions[_j2].x*width/2, 
      _s.skeletonPositions[_j2].y*height/2);
  }
}

void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}  

void moveEvent(SkeletonData _b, SkeletonData _a) 
{
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}

void sendOsc(int particle_color) {
  OscMessage msg = new OscMessage("/inputs");
  msg.add((float)particle_color); 
  oscP5.send(msg, dest);
    }

/*void thunder1(int depth, int x){
  int index_colour=int(random(0, 7));    
  color filling=vectorColours[index_colour];  
  print(depth);
  if (depth < 10) {
          print("inside depth<10");

    strokeWeight(2);//bolt is a little thicker than a line
    stroke(filling); 
    line(0,0,0,height/10); // draw a line going down
    {
      translate(0,height/10); // move the space downwards
      rotate(random(-0.5,0.5));  // random wiggle
 
      if (random(1.0) < 0.1){ // &nbsp;ing  
      print("inside random");
        rotate(0.3); // rotate to the right
        scale(0.4); // scale down
        pushMatrix(); // now save the transform state
        thunder(depth + 1); // start a new branch!
        popMatrix(); // go back to saved state
        rotate(-0.6); // rotate back to the left
        pushMatrix(); // save state
        thunder(depth + 2);   // start a second new branch
        popMatrix(); // back to saved state        
     }
      else { // no branch - continue at the same depth  
        thunder(depth);
            }
    }
  }
} */ 
