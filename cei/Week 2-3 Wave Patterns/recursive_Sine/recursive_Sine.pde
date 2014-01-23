float x, y, prevX, prevY;
Wave xWave = new Wave(PI/2, .01, 10, 0);
Wave yWave = new Wave(0, .01, 10, 0);

float tx, ty;
float t;
int limit = 1;

boolean hasChanged;
boolean isAuto = true;


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
  if (isAuto) {
    t+=.00001 ;
    limit += noise(t);
    limit%=3;
  }
  float xspeed = xWave.wave(int(limit));
  float yspeed = yWave.wave(int(limit));
  x += xspeed;
  y += yspeed;

  pushMatrix();
  translate(tx, ty);
  //ellipse(x, y, 1, 1);
  line(x, y, prevX, prevY);
  prevX = x;
  prevY = y;
  popMatrix();

  fill(0);
  rect(0, 0, width, 40);
  fill(255);
  text("LIMIT: " + Float.toString(limit).substring(0, 1), 20, 20);

  hasChanged = false;
}

void keyPressed() {

  switch(keyCode) {
  case UP:
    isAuto = false;
    limit++;
    hasChanged = true;
    break;
  case DOWN:
    isAuto = false;
    limit--;  
    hasChanged = true;
    break;
  case ENTER:
    isAuto = true;
    break;
  }

  limit = constrain(limit, 0, 10);
}

