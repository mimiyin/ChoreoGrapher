void setup() {
  size(200, 200);
}

void draw() {
  background(255);
  fill(0);
  int x = int(random(0, width*10));
  x = x-x%width;  
  int y = int(random(0, height*10));
  y=y-y%height;
  rect(x, y, width, height);
}

