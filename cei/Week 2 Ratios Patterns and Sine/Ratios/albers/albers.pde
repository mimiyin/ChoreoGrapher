Area background;
Area foreground;
int top, bottom;

void setup() {
  size(displayWidth, displayHeight);  
  noStroke();
  rectMode(CENTER);

  top = 200;
  bottom = 100;

  PVector rgb = new PVector(random(255), random(255), random(255));
  PVector speed = new PVector(random(1), random(1), random(1));
  rgb.mult(.5);
  background = new Area(rgb, speed);
  speed.mult(.1);
  foreground = new Area(rgb, speed);
}


void draw() { 

  PVector b = background.run();
  // Set the background color
  background(b.x, b.y, b.z);

  PVector f = foreground.run();
  // Set the foreground color
  fill(f.x, f.y, f.z);

  // Draw the rect
  rect (width/2, height/2, width/2, height/2);
}  
  

void keyPressed() {
  switch(keyCode) {
  case UP:
    top++;
    bottom--;
    break;

  case DOWN:
    top--;
    bottom++;
    break;

  case RIGHT:
    top++;
    bottom++;
    break;

  case LEFT:
    top--;
    bottom--;
    break;
  }

  top = constrain(top, 0, 255);
  bottom = constrain(bottom, 0, 255);
  
  if(top-bottom < 0) {
     int t = top;
     top = bottom;
     bottom = t; 
  }
  
  println("TOP: " + top + "\t\tBOTTOM: " + bottom);
}

