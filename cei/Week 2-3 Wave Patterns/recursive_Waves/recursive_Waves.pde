// Control how many times to recurse
// Control which wave to use at which level of recursion
// Control whether to modulate freq or amp

float tx, ty;
float x, y, prevX, prevY;
int level;
int cap = 0;
int [] indices = { 
  0, 1, 2, 3, 4
};

String [] types = { 
  "SIN", "COS", "SQU", "SAW", "TAN"
};

float frequency = 0.01;
float amplitude = 5;
float offset = 0;

Cursor xCursor = new Cursor(PI/2, frequency, amplitude, offset);
Cursor yCursor = new Cursor(0, frequency, amplitude, offset);

void setup() {
  size(800, 600); 
  background(255);
  tx = width/2;
  ty = height/2;
}

void draw() {
  if (x > tx || x < -tx || y > ty || y < -ty) {
    if (x > tx) {
      x = -tx;
    }   
    else if(x < -tx) {
      x = tx;
    } 
    if (y > ty) { 
      y = -ty;
    }
    else if(y < -ty) {
      y = ty;
    }
    prevX = x;
    prevY = y;
  }


  float xspeed = xCursor.run(0);
  float yspeed = yCursor.run(0);

  x += xspeed;
  y += yspeed;

  pushMatrix();
  translate(tx, ty);
  stroke(0, 128);
  line(x, y, prevX, prevY);
  prevX = x;
  prevY = y;
  popMatrix();

  label();
}

void label() {
  fill(0);
  rect(0, 0, width, 50);
  fill(255);
  text("Press RIGHT/LEFT to adjust levels of recursion: " + (cap+1), 10, 20);
  text("Press NUM KEY and UP/DOWN to change wave type at each recursion level: (1) " + types[indices[0]] + "\t(2) " + types[indices[1]] + "\t(3) " + types[indices[2]] + "\t(4) " + types[indices[3]] + "\t(5) " + types[indices[4]], 10, 40);
}

void display(float yoff, float y) {
  pushMatrix();
  translate(0, yoff);
  line(x, 0, x, y);
  popMatrix();
}

void keyPressed() {

    // SPACEBAR
    switch(keyCode) {
    case UP:
      indices[level]++;
      break;
    case DOWN:
      indices[level]--;
      break;
    case RIGHT:
      cap++;
      break;
    case LEFT:
      cap--;
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
  }
}
