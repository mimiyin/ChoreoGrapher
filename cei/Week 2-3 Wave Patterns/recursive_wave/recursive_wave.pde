float x, y, prevX, prevY, theta;
float xdir = 1;
float ydir = 1;
float tx, ty;

float limit = 2;
float frequency = 1;
float amplitude = 5;
float offset = 0;

boolean auto;
float t= 0;

void setup() {
  size(600, 600); 
  background(255);
  fill(0);  
  tx = width/2;
  ty = height/2;
}

void draw() {
  theta += 0.01;

  if (x > tx || x < -tx || y > ty || y < -ty) {    
    if (x > tx) {
      x = -tx;
      prevX = x;
    }   
    else if (x < -tx) {
      x = tx;
      prevX = x;
    } 
    if (y > ty) { 
      y = -ty;
      prevY = y;
    }
    else if (y < -ty) {
      y = ty;
      prevY = y;
    }
  }

  if (auto) {
    t+=0.0001;
    limit += abs((cos(t)*tan(t) + 1)*.01); 
    limit%=3;
  }

  float xspeed = wave(theta, frequency, amplitude, offset, limit, 0);
  float yspeed = wave(theta-PI, frequency, amplitude, offset, limit, 0);
  x += xspeed*xdir;
  y += yspeed*ydir;

  pushMatrix();
  translate(tx, ty);
  line(x, y, prevX, prevY);
  prevX = x;
  prevY = y;

  popMatrix();

  label();
}

void label() {
  fill(0);
  rect(0, 0, width, 30);
  fill(255);
  text("Press ENTER to toggle AUTO: " + auto + "\t\t\t\u2B0C LIMIT: " + int(limit) + "\t\t\tf/v FREQ: " + frequency + "\t\t\ta/z AMP: " + amplitude, 10, 20);
}


float wave(float t, float f, float a, float o, float l, float c) {
  if (c >= l) {
    return sine(t, f, a, o);
  }
  else {
    c++;
    f = wave(t, f, a, a, l, c);
    a = wave(t, f, a, a, l, c); 
    return sine(t, f, a, o);
  }
}

float sine(float t, float f, float a, float o) {
  return sin(f*t)*a + o;
}

void keyPressed() {
  switch(keyCode) {
  case RIGHT:
    limit++;
    break;
  case LEFT:
    limit--;
    break;
  case ENTER:
    auto = !auto;
    break;
  }

  limit = constrain(limit, 0, 5);

  if (key == 'f' || key == 'v') {
    frequency += (key == 'f' ? 0.01 : -0.01);
    frequency = constrain(frequency, 0.01, PI);
  }
  else if (key == 'a' || key == 'z') {
    amplitude += (key == 'a' ? 1 : -1);
    amplitude = constrain(amplitude, 0, width);
  }
}

