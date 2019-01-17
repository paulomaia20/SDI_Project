//========== Shapes ==========
PShape silhouette;
PShape head;
PShape body;
PShape left_arm;
PShape right_arm;
PShape left_leg;
PShape right_leg;

//========== Colors definition ================
color red=color(239, 51, 64);
color yellow=color(243, 207, 85);
color orange=color(255, 108, 47);
color green=color(136, 176, 75);
color blue=color(87, 140, 169);
color purple=color(173, 94, 153);
color grey=color(129, 131, 135);

void setup() {
  fullScreen();
  silhouette = loadShape("silhouette.svg");
  head = loadShape("head.svg");
  body = loadShape("body.svg");
  left_arm = loadShape("left_arm.svg");
  right_arm = loadShape("right_arm.svg");
  left_leg = loadShape("left_leg.svg");
  right_leg = loadShape("right_leg.svg");
}

void draw() {
  background(255);
  
  //shape(silhouette, mouseX, mouseY);

  head.disableStyle();
  fill(green);
  noStroke();
  shape(head, mouseX, mouseY);
  
  body.disableStyle();
  fill(yellow);
  noStroke();
  shape(body, mouseX, mouseY);
  
  left_arm.disableStyle();
  fill(purple);
  noStroke();
  shape(left_arm, mouseX, mouseY);
  
  right_arm.disableStyle();
  fill(red);
  noStroke();
  shape(right_arm, mouseX, mouseY);
  
  left_leg.disableStyle();
  fill(grey);
  noStroke();
  shape(left_leg, mouseX, mouseY);
  
  right_leg.disableStyle();
  fill(orange);
  noStroke();
  shape(right_leg, mouseX, mouseY);
  
}
