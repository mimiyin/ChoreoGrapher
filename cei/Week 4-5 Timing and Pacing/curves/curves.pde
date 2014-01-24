
// exp controls how steep the spike is
// bspeed controls how long it takes to spike
float x, y;
float base, speed, exp;

int mode = 0;
int modes = 4;

boolean down;

void setup() {
  size(800, 400);
  reset();
}

void draw() {
  x++;
  float value = curv();
  y = down ? value : height-value;
  noStroke(); 
  fill(255);
  ellipse(x, y, 10, 10);
  label();
}

float curv() {
  switch(mode) {
  case 1:
    return exponential();
  case 2:
    return logarithmic();
  case 3:
    return bounce();
  default:
    return linear();
  }
}

void label() {
  String label = "MODE: " + mode + "\ndown: " + down + "\nBASE: " + base + "\nSPEED: " + speed + "\nEXP: " + exp;
  int tw = 100;
  fill(0);
  rect(width-tw, 0, tw, 120);
  fill(255);
  textAlign(LEFT);
  text(label, width-tw, 20);
}

float linear() {
  float m = (float)height/(float)width;
  return m*x;
}

float exponential() {
  base+=speed;
  return pow(base, exp);
}

float logarithmic() {
  exp+=speed;
  return log(exp)*50;
}

float bounce() {
  base = sin(x*0.1)*200 + 200;
  return log(base)*50;
}

void reset() {
  background(0);
  x = 0;
  base = 0;

  switch(mode) {
  case 1:
    speed = 0.005;
    exp = 20;
    break;
  case 2:
    exp = 0;
    speed = 1;
    break;
  case 3:
    speed = 0.01;
    exp = 20;
    break;
  }
}


void keyPressed() {
  
    switch(keyCode) {
    case RIGHT:
      mode++;
      break;
    case LEFT:
      mode--;
      break;
    case UP:
      down = false;
      break;
    case DOWN:
      down = true;
      break;
    }

    if (mode >= modes || mode < 0) {
      mode = (modes + abs(mode))%modes;
    }

    reset();
    
}

