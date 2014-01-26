class Dartboard {

  Dartboard() {
  }


  int fire(float min, float max, float[] zones) {
    float dart = random(min, max); 
    for (int i = 0; i < zones.length; i++) {
      if ( dart <= zones[i]) {
        return i;
      }
    }
    return -1;
  }
}

