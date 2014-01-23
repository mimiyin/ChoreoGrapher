float x, y, prevX, xPos;

float w = 1;
float h = 10;

float d;
float interval = 1;

int mode = 1;
String [] modes = { "RANDOM", "SINE", "TAN", "MANUAL" };

void setup() {
  size(800, 400);
  background(255);
}

void draw() {

  if (x-prevX >= interval) {
    fill(0);
    rect(x, y, w, h);
    interval = calc();
    prevX = x;
  }

  x+=interval;

  if (x > width) {
    y += h;
    x = -(x-width);
    prevX = x;
  }

  if (y > height) {
    background(255);
    x = 0;
    y = 0;
  }
  
  println("MODE: " + modes[mode]);
}

float calc() {

  d++;
  switch(mode) {
  case 0:
    return random(width);
  case 1:
    return sin(d)*10 + 10;
  case 2:
    return abs(tan(radians(d)))*10 + 1;
  default:
    return interval;
  }
}

void keyPressed() {

  switch(keyCode) {
  case UP:
    mode++;
    break;
  case DOWN:
    mode--;
    break;
  case RIGHT:
    interval++;
    break;
  case LEFT:
    interval--;
    break;
  }

  interval = constrain(interval, 1, width);
  mode = constrain(mode, 0, modes.length);
}

