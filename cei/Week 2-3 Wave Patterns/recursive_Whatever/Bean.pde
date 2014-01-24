// 4 levels
// TAN, COS, SQU, SAW, TAN

class Bean {
  float x, y, prevX, prevY;
  Bean(float f, float a, float o, int c, int[] i, boolean s, boolean e ) {
    frequency = f;
    amplitude = a;
    offset = o;
    cap = c;
    indices = i;
    show = s;
    erase = e;    
  }
  
  void display(float _x, float _y) {
    float r = random(dist(_x, _y, prevX, prevY));
    float dir = random(TWO_PI);
    x = r*cos(dir);
    y = r*sin(dir);
    prevX = _x;
    prevY = _y;
    println(r + "\t" + x + "\t" + y);
    noStroke();
    fill(0);
    ellipse(x, y, 10, 10); 
  }
  
  
  
  
  
  
}
