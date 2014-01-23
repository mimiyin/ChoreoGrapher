float x, y, prevX, prevY, theta, xoff;
float xdir = 1;
float ydir = 1;
float offsetX, offsetY;

float tx, ty;

void setup() {
  size(600, 600); 
  background(255);
  fill(0);  
  tx = width/2;
  ty = height/2;
}

void draw() {
  theta += 0.01;
//  if(x > width) {
//   x=0;
//  }
//  else if(x < 0) {
//   x = width; 
//  }
//  
//  if(y > height) {
//   y =0;
//    
//  }
//  
//  else if(y < 0) {
//   y = height; 
//  }

  if(x > tx || x < -tx) {
   xdir *= -1; 
  }
  if(y > ty || y < -ty) {
   ydir *= -1; 
  }
  //xoff++;
  float limit = wave(false, theta, 1, 2, 0, 0, 1);
  println(theta%TWO_PI + "\t" + limit);
  float amp = wave(false, theta, 1, 1, 1, 0, limit);//width/4; //sine(theta, 1, 10, 10);
  float xspeed = wave(false, theta, 1, amp, 0, 0, limit);
  float yspeed = wave(true, theta, 1, amp, 0, 0, limit);
  //offsetX = wave(false, theta, 1, amp, 0, 0, 0)*xdir;
  //offsetY = wave(true, theta, 1, amp, 0, 0, 0)*ydir;
  //x = xspeed;// + cos(theta)*50;
  x += xspeed*xdir;// + offsetX;
  y += yspeed*ydir;// + offsetY;
  //y = yspeed;// + sin(theta)*50;
  //ellipse(x, y, 1, 1);
  pushMatrix();
  translate(tx, ty);
  line(x, y, prevX, prevY);
  prevX = x;
  prevY = y;

  popMatrix();
  
}


float wave(boolean isSine, float t, float f, float a, float o, int c, float lim) {
  if (c >= lim) {
    return isSine ? sine(t, f, a, o) : cosine(t, f, a, o);
  }
  else {
    c++;
    f = wave(!isSine, t, f, a, o, c, lim);
    a = wave(isSine, t, f, a, o, c, lim); 
    return isSine ? sine(t, f, a, o) : cosine(t, f, a, o);
  }
}

float sine(float t, float f, float a, float o) {
  return sin(f*t)*a + o;   
}

float cosine(float t, float f, float a, float o) {
  return cos(f*t)*a + o;   
}
