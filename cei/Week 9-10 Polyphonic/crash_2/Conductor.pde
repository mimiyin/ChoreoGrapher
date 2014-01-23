class Conductor {
  float freq = 0.01;
  float amp = 1;
  float off = 0;

  int max;
  ArrayList<Voice> voices = new ArrayList<Voice>();

  Dartboard db = new Dartboard();
  
  Conductor(int _max, ArrayList<Voice>voices) {
    max = _max;
    for (int i = 0; i < max; i++) {
      voices.add
    }
  }

  void run() {
    PVector offset = new PVector(0, 0);
    float [] values = new float [voices.size()];
    PVector [] offsets = new PVector [voices.size()];

    for (int i = 0; i < voices.size(); i++) {
      Voice thisVoice = voices.get(i);
      if (thisVoice.on) {
        float value = thisVoice.run(offset);
        if (showWaves) {
          display(value, value <= 0 ? offset.x : offset.y, thisVoice.col);
        }
        if (value >=0) {
          offset.y += value;
        }
        else {
          offset.x += value;
        }
        values[i] = value;
      }
      else {
        values[i] = 0;
      }
      offsets[i] = new PVector(offset.x, offset.y);
    }

    return db.fire(offset.x, offset.y, offsets);
  }
}


