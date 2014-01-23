float x, y, t, f, a, o;

void setup() {
  size(800, 400);
  background(255);
  f = 1;
  a = height/4;
  o = height/2;
}


void draw() {
  if (x > width) {
    x = 0;
    background(255);
  }
  x++;
  t+=f/100;
  y = sin(t)*a + o;
  ellipse(x, y, 1, 1);
}


void keyPressed() {
  switch(keyCode) {
  case UP:
    f++;
    break;
  case DOWN:
    f--;
    break;
  case RIGHT:
    a++;
    break;
  case LEFT:
    a--;
    break;
  }
}

