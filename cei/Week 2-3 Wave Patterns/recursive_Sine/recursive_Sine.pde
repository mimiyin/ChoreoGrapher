float x, y, prevX, prevY;
float frequency = 0.01;
float amplitude = 5;
float offset = 0;

Sine xWave = new Sine(PI/2, frequency, amplitude, offset);
Sine yWave = new Sine(0, frequency, amplitude, offset);

float tx, ty;
float t, lim;
int limit = 2;

boolean auto;


void setup() {
  size(800, 600); 
  background(255);
  fill(0);  
  tx = width/2;
  ty = height/2;
  noiseSeed(0);
  noiseDetail(4, .67);
}

void draw() {
  if (auto) {
    t+=.001;
    lim += noise(t);
    println("LIMIT: " + lim);
    limit = int(lim%3);
  }

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

  float xspeed = xWave.wave(0);
  float yspeed = yWave.wave(0);
  x += xspeed;
  y += yspeed;

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
  text("AUTO: " + auto + "\t\tLIMIT: " + limit + "\t\tFREQ: " + frequency + "\t\tAMP: " + amplitude, 10, 20);
}

void reset() {
  xWave.reset();
  yWave.reset();
}

void keyPressed() {

  switch(keyCode) {
  case RIGHT:
    auto = false;
    limit++;
    break;
  case LEFT:
    auto = false;
    limit--;  
    break;
  case ENTER:
    auto = true;
    break;
  }

  limit = constrain(limit, 0, 10);

  if (key == 'f' || key == 'v') {
    frequency += (key == 'f' ? 0.001 : -0.001);
    frequency = constrain(frequency, 0.001, PI);
    xWave.setF(frequency);
    yWave.setF(frequency);
  }
  else if (key == 'a' || key == 'z') {
    amplitude += (key == 'a' ? 1 : -1);
    amplitude = constrain(amplitude, 0, width);
    xWave.setA(amplitude);
    yWave.setA(amplitude);
  }
}

