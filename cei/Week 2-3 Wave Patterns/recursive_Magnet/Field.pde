class Field {

  float x, y;

  Field() {
  }

  void display(float _x, float _y) {
    for (int x = -tx; x < tx; x+=20) {
      for (int y = -ty; y < ty; y+=20) {
        float xdisp = (x - _x)/20;
        float ydisp = (y - _y)/20;
        strokeWeight(0.05*abs(xdisp*ydisp));
        stroke(0);
        line(x, y, x+xdisp, y+ydisp);
        noStroke();
      }
    }
  }
}

