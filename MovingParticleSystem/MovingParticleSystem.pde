import processing.video.*; //<>// //<>// //<>// //<>//
import java.awt.Rectangle;
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

Kinect kinect;
int timeClicked, elapsed_time;
Cursor c; 
Capture video;
final int stateWaitBeforeProgram = 0;
final int stateWaitAfterProgram = 2;
final int stateNormalProgram = 1;
int state = stateWaitBeforeProgram;
User newUser;
int id_user=1;
ArrayList <SkeletonData> bodies;
bouncyWord title;
PrintWriter output;
Particle[] particles;
Timer timer, flashTimer;        // One timer object
int totalParticles = 0; // totalDrops
PFont mono;
PShape svg; 
boolean vanishTransition=false; 
boolean caughtState=false; 

void setup() {
  fullScreen();

  //Set standard font
  mono = createFont("FiraSans-Regular.ttf", 32);
  textFont(mono);

  //Set bouncy title
  title = new bouncyWord("Raindrop", width/2);

  newUser= new User(id_user);
  kinect = new Kinect(this);
  bodies = new ArrayList<SkeletonData>();
  c = new Cursor(12); //Cursor with radius 12 

  frameRate(120);
  smooth();
  svg = loadShape("button4.svg");

  // create a file in the sketch directory
  int d = day();     // Values from 1 - 31
  output = createWriter("statistics_user" + id_user + "_day" + d + ".txt");

  particles = new Particle[50];      // Create 50 spots in the array - Variar de acordo com o que decidirmos. Tem de ter um máximo de particulas, funçao do tempo da simulação
  timer = new Timer(400);    // Create a timer that goes off every X milliseconds. Number of particles is a function of the timer. 
  timer.start();             // Starting the timer

  flashTimer = new Timer(5000);

  //Hide the cursor
  noCursor();
}

void draw() {

  int s = second();  // Values from 0 - 59
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23

  if (state == stateWaitBeforeProgram) {
    background(255);

    textAlign(CENTER);
    textSize(50);
    fill(0); 
    title.draw();


    textSize(20);
    textAlign(CENTER, CENTER);
    text ("Passa o cursor por cima do botão para iniciar o jogo", width/2, height/2+300);

    // Place button
    shape(svg, width/2-width/8, height/2, 250*2, 75*2);

    //Check if cursor is over the button
    checkMouseHoverAction(width/2-width/12, height/2, mouseX, mouseY, 350, 100);

    /*for (int i=0; i<bodies.size (); i++) 
     {
     c.run(int(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].x*width), int(bodies.get(i).skeletonPositions[Kinect.NUI_SKELETON_POSITION_HAND_RIGHT].y*height));
     }*/

    //SE NÃO TIVEREM ACESSO À KINECT:
    fill(color(255, 255, 255));
    c.run(mouseX, mouseY);
  } else if (state==stateNormalProgram) {

    background(255);
    //  shape(svg, width-width/12, height-height/8, width/16, height/8);
    // fill(0);  //mudar para cor da partícula apanhada ?? pensar melhor ! 
    // shape(svg2, width-width/12, height-height/8, width/16, height/8);

    c.run(mouseX, mouseY);


    if (timer.isFinished()) {

      particles[totalParticles] = new Particle();
      // Increment totalParticles
      totalParticles ++ ;
      timer.start();
    }


    // Move and display all drops
    for (int i = 0; i < totalParticles; i++ ) {
      particles[i].update();
      particles[i].display();
      if (particles[i].getCaughtState()==true   )
      { 
        particles[i].updateOpacity();
      }
      if (c.intersect(particles[i])) {
        particles[i].setCaughtState(true); 

        if (particles[i].getOpacity()<=0)
        {
          particles[i].caught();
          (newUser.getColoursStatistics())[particles[i].index_colour]++;
        }
      }
    }
    
    elapsed_time=(millis()-timeClicked)/1000; 

    if (elapsed_time>5) {

      state=stateWaitAfterProgram; 
      showStats(s, m, h);

      //Restart and reset variables - user id and particles array 
      id_user++; 
      newUser = new User(id_user); 
      totalParticles = 0;
    }
  }
} 

void showStats(int s, int m, int h)
{

  background(255);

  textSize(50);
  fill(0);
  textAlign(CENTER, CENTER);
  text("O jogo terminou", width/2, height/2);
  textSize(15);
  text("Carrega no rato para iniciar novamente.", width/2, height/2+75);

  textAlign(LEFT, LEFT);
  textSize(20);
  text("Tempo de jogo (s):", width/2-width/12, height/2-height/4-140);
  text(elapsed_time, width/2+width/12, height/2-height/4-140);

  // Mostrar estatísticas do utilizador
  text("Partículas vermelhas:", width/2-width/12, height/2-height/4);
  text(newUser.getColoursStatistics()[0], width/2+width/12, height/2-height/4);

  text("Partículas amarelas:", width/2-width/12, height/2-height/4-20);
  text(newUser.getColoursStatistics()[1], width/2+width/12, height/2-height/4-20);

  text("Partículas laranjas:", width/2-width/12, height/2-height/4-40);
  text(newUser.getColoursStatistics()[2], width/2+width/12, height/2-height/4-40);

  text("Partículas verdes:", width/2-width/12, height/2-height/4-60);
  text(newUser.getColoursStatistics()[3], width/2+width/12, height/2-height/4-60);

  text("Partículas azuis:", width/2-width/12, height/2-height/4-80);
  text(newUser.getColoursStatistics()[4], width/2+width/12, height/2-height/4-80);

  text("Partículas roxas:", width/2-width/12, height/2-height/4-100);
  text(newUser.getColoursStatistics()[5], width/2+width/12, height/2-height/4-100);

  text("Partículas cinzentas:", width/2-width/12, height/2-height/4-120);
  text(newUser.getColoursStatistics()[6], width/2+width/12, height/2-height/4-120);

  String formatStr = "%-25s %-15s";

  write("id " + id_user);
  write("início às " + h + ":" + m + ":" + s);
  write("\n");
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

void write(String str) {
  output.println(str);
}


void checkMouseHoverAction(int rectXPos, int rectYpos, int xpos, int ypos, int rectWidth, int rectHeight)
{
  if (xpos >= rectXPos && xpos <= rectXPos+rectWidth && 
    ypos >= rectYpos && ypos <= rectYpos+rectHeight && state == stateWaitBeforeProgram )
  {

    state=stateNormalProgram ;
    timeClicked=millis();
  }
}

void mousePressed() {

  if (state == stateWaitAfterProgram) {
    state=stateNormalProgram ;
    timeClicked=millis(); 
    //Reset variables!
  }
} 

void captureEvent(Capture c) {
  c.read();
}

// Kinect lib
void drawPosition(SkeletonData _s) 
{
  noStroke();
  fill(0, 100, 255);
  String s1 = str(_s.dwTrackingID);
  text(s1, _s.position.x*width/2, _s.position.y*height/2);
}

void drawSkeleton(SkeletonData _s) 
{
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
