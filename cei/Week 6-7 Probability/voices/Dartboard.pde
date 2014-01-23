class Dartboard {

  Dartboard() {
  }


  int fire(float min, float max, PVector[] zones) {
    float dart = random(min, max); 
    for (int i = 0; i < zones.length; i++) {
      if ( dart < 0 && dart >= zones[i].x) {
        return i;
      }
      else if (dart >=0 && dart <= zones[i].y) {
        return i;
      }
    }
    return 0;
  }
}

