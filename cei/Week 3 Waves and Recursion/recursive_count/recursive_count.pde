
float limit = 4;
float x, y;

void setup() {
  size(400, 400);  
  background(255);
  fill(0);
  frameRate(10);
}


void draw() {
  limit = random(9);
  count(0);
}

void count(int c) {
  if (c > limit) return;


  for (int i = 0; i < c; i++) {
    x +=10;
    if (x > width) {
      x = 0;
      y+=10;
    }
    if(y > height) {
     y = 0; 
    }
    textSize(10/c);
    text(i, x, y);
  }

  count(c+1);
}

