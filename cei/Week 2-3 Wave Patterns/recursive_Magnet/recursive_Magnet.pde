// Control how many times to recurse
// Control which wave to use at which level of recursion
// Control whether to modulate freq or amp


int tx, ty;
float x, y;
int level;
int cap = 0;
int [] indices = { 
  0, 1, 2, 3, 4
};

String [] types = { 
  "SIN", "COS", "SQU", "SAW", "TAN"
};

float frequency = 0.01;
float amplitude = 100;
float offset = 0;
Cursor xCursor = new Cursor(PI/2, frequency, amplitude, offset);
Cursor yCursor = new Cursor(0, frequency, amplitude, offset);

boolean show, erase;

Field field = new Field();

void setup() {
  size(800, 600); 
  background(255);
  tx = width/2;
  ty = height/2;
  noiseSeed(0);
  noiseDetail(4, .67);
}

void draw() {
  if (erase) {
    background(255);
  }

  if (x > tx || x < -tx || y > ty || y < -ty) {    
    if (x > tx) {
      x = -tx;
    }   
    else if (x < -tx) {
      x = tx;
    } 
    if (y > ty) { 
      y = -ty;
    }
    else if (y < -ty) {
      y = ty;
    }
  }

  float xspeed = xCursor.run(0);
  float yspeed = yCursor.run(0);

  x += xspeed;
  y += yspeed;


  pushMatrix();
  translate(tx, ty);
  field.display(x, y);
  if (show) {
    fill(255, 0, 0);
    ellipse(x, y, 10, 10);
  }
  popMatrix();

  label();
}

void label() {
  fill(0);
  rect(0, 0, width, 50);
  fill(255);
  text("Press RIGHT/LEFT to adjust levels of recursion: " + (cap+1) + "\t\t\tPress f/v to +/- FREQ: " + frequency + "\t\t\tPress a/z to +/- AMP: " + amplitude, 10, 20);
  text("Press NUM KEY and UP/DOWN to change wave type at each recursion level: (1) " + types[indices[0]] + "\t(2) " + types[indices[1]] + "\t(3) " + types[indices[2]] + "\t(4) " + types[indices[3]] + "\t(5) " + types[indices[4]], 10, 40);
}

void keyPressed() {
  // SPACEBAR
  switch(keyCode) {
  case UP:
    indices[level]++;
    indices[level] = constrain(indices[level], 0, indices.length-1);
    break;
  case DOWN:
    indices[level]--;
    indices[level] = constrain(indices[level], 0, indices.length-1);
    break;
  case RIGHT:
    cap++;
    cap = constrain(cap, 0, indices.length-1);
    break;
  case LEFT:
    cap--;
    cap = constrain(cap, 0, indices.length-1);
    break;
  case ENTER:
    show = !show;
    break;
  case TAB:
    erase = !erase;
    break;
  }

  if (key == CODED) {
    if (keyCode == UP || keyCode == DOWN) {
      indices[level] = constrain(indices[level], 0, indices.length-1);
    }
    else if (keyCode == RIGHT || keyCode == LEFT) {
      cap = constrain(cap, 0, indices.length-1);
      xCursor.reset();
      yCursor.reset();
    }
  }
  else {
    int k = parseInt(key)-49;
    if (k >=0 && k < indices.length) {
      level = k;
    }

    if (key == 'f' || key == 'v') {
      frequency += (key == 'f' ? 0.001 : -0.001);
      frequency = constrain(frequency, 0.001, PI);
      xCursor.setF(frequency);
      yCursor.setF(frequency);
    }
    else if (key == 'a' || key == 'z') {
      amplitude += (key == 'a' ? 1 : -1);
      amplitude = constrain(amplitude, 0, width);
      xCursor.setA(amplitude);
      yCursor.setA(amplitude);
    }
  }
}

