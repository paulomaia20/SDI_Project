PShape svg;

void setup() {
  size(450, 900, P2D);
  //svg = loadShape("male.svg");
  //svg = loadShape("female.svg");
  svg = loadShape("feet.svg");
}

void draw() {
  background(255);
  shape(svg);
}
